module ChromeData
  class Vehicle < BaseRequest
    class Engine < Struct.new(:type); end

    attr_accessor :model_year, :division, :model, :styles, :engines, :standard

    def self.request_name
      "describeVehicle"
    end

    def self.find_by_vin(vin)
      request 'vin' => vin
    end

    def self.parse_response(response)
      return unless find_elements('vinDescription', response).first
      new response
    end

    private
    def initialize(response)
      @response = response
      vin_description = self.class.find_elements('vinDescription', @response).first
      @model_year = vin_description.attr('modelYear').to_i
      @division = vin_description.attr('division')
      @model = vin_description.attr('modelName')
      parse_styles
      parse_standard
      parse_engines
    end

    def parse_styles
      @styles = self.class.find_elements('style', @response).map do |e|
        create_style e
      end
    end

    def parse_standard
      @standard = self.class.find_elements('standard', @response).map { |e|
        {
          "id" => find_standard_id(e),
          "description" => find_standard_description(e),
          "category" => find_standard_category(e),
          "style_ids" => collect_style_ids(e)
        }
      }
    end

    def parse_engines
      @engines = self.class.find_elements('engine', @response).map do |e|
        Engine.new(e.at_xpath("x:engineType", 'x' => @response.body.namespace.href).text)
      end
    end

    def create_style(element)
      Style.new(
        id: element.attr('id').to_i,
        name: element.attr('name'),
        trim: element.attr('trim'),
        name_without_trim: element.attr('nameWoTrim'),
        body_types: collect_body_types(element)
      )
    end

    def collect_body_types element
      element.xpath("x:bodyType", 'x' => @response.body.namespace.href).map { |bt|
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

    def find(element, target)
      element.children.find { |e| e.name == target }
    end

    def collect_style_ids(element)
      element.xpath("x:styleId", 'x' => @response.body.namespace.href).map { |style_id|
        style_id.text.to_i
      }
    end
  end
end
