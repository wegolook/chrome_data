module ChromeData
  class Vehicle < BaseRequest
    class Engine < Struct.new(:engine_type, :installed_cause, :fuel_type, :cylinders, :displacement); end

    attr_accessor :model_year, :division, :model, :styles, :engines, :standard, :trim_name, :body_type, :driving_wheels

    def self.request_name
      "describeVehicle"
    end

    def self.find_by_vin(vin)
      request 'vin' => vin, 'switch' => 'IncludeDefinitions'
    end

    def self.parse_response(response)
      return unless find_elements('vinDescription', response).first
      self.new response
    end

    private
    def initialize(response)
      vin_description = self.class.find_elements('vinDescription', response).first
      vehicle_description = response.body
      @vin = vin_description.attr('vin')
      @model_year = vin_description.attr('modelYear').to_i
      @division = vin_description.attr('division')
      @model = vin_description.attr('modelName')
      @trim_name = vehicle_description.attributes['bestTrimName'] ? vehicle_description.attributes['bestTrimName'].value : nil
      @body_type = vin_description.attr('bodyType')
      @driving_wheels = vin_description.attr('drivingWheels')
      parse_styles response
      parse_standard response
      parse_engines response
      parse_generic_equipment response
    end

    def parse_styles(response)
      @styles = self.class.find_elements('style', response).map do |e|
        create_style e, response
      end
    end

    def parse_generic_equipment(response)
      @generic_equipment = self.class.find_elements('genericEquipment', response).map { |e|
        {
          "group" => find_equipment_group(e),
          "header" => find_equipment_header(e),
          "category" => find_equipment_category(e)
        }
      }
    end

    def parse_standard(response)
      @standard = self.class.find_elements('standard', response).map { |e|
        {
          "id" => find_standard_id(e),
          "description" => find_standard_description(e),
          "category" => find_standard_category(e),
          "style_ids" => collect_style_ids(e, response)
        }
      }
    end

    def parse_engines(response)
      @engines = self.class.find_elements('engine', response).map do |e|
        engine_type = e.at_xpath("x:engineType", 'x' => response.body.namespace.href).text
        installed_cause = e.at_xpath("x:installed/@cause", 'x' => response.body.namespace.href).text
        fuel_type = e.at_xpath("x:fuelType", 'x' => response.body.namespace.href).text
        raw_cylinders = e.at_xpath("x:cylinders", 'x' => response.body.namespace.href)
        cylinders = raw_cylinders ? raw_cylinders.text : 'N/A'
        raw_displacement = e.at_xpath("x:displacement/@liters", 'x' => response.body.namespace.href)
        displacement = raw_displacement ? raw_displacement.text : 'N/A'

        Engine.new(engine_type, installed_cause, fuel_type, cylinders, displacement)
      end
    end

    def create_style(element, response)
      Style.new(
        id: element.attr('id').to_i,
        name: element.attr('name'),
        trim: element.attr('trim'),
        name_without_trim: element.attr('nameWoTrim'),
        body_types: collect_body_types(element, response)
      )
    end

    def collect_body_types(element, response)
      element.xpath("x:bodyType", 'x' => response.body.namespace.href).map { |bt|
        Style::BodyType.new(bt.attr('id').to_i, bt.text)
      }
    end

    def find_standard_id(element)
      if id = find(element, "header")
        id.attributes["id"].value.to_i
      end
    end

    def find_standard_description(element)
      if desc = find(element, "description")
        desc.text
      end
    end

    def find_standard_category(element)
      if cat = find(element, "header")
        cat.text
      end
    end

    def find_equipment_group(element)
      definition = find(element,"definition")
      if group = find(definition,"group")
        group.text
      end
    end

    def find_equipment_header(element)
      definition = find(element,"definition")
      if header = find(definition,"header")
        header.text
      end
    end

    def find_equipment_category(element)
      definition = find(element,"definition")
      if category = find(definition,"category")
        category.text
      end
    end

    def find(element, target)
      element.children.find { |e| e.name == target }
    end

    def collect_style_ids(element, response)
      element.xpath("x:styleId", 'x' => response.body.namespace.href).map { |style_id|
        style_id.text.to_i
      }
    end
  end
end
