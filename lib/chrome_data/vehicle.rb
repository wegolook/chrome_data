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
      if vin_description = find_elements('vinDescription', response).first
        self.new response
      end
    end

    def initialize response
      vin_description = self.class.find_elements('vinDescription', response).first
      @model_year = vin_description.attr('modelYear').to_i
      @division = vin_description.attr('division')
      @model = vin_description.attr('modelName')
      parse_styles response
      parse_standard response
      parse_engines response
    end

    private
    def parse_styles(response)
      @styles = self.class.find_elements('style', response).map do |e|
        Style.new(
          id: e.attr('id').to_i,
          name: e.attr('name'),
          trim: e.attr('trim'),
          name_without_trim: e.attr('nameWoTrim'),
          body_types: e.xpath("x:bodyType", 'x' => response.body.namespace.href).map do |bt|
            Style::BodyType.new(bt.attr('id').to_i, bt.text)
          end
        )
      end
    end

    def parse_standard(response)
      @standard = self.class.find_elements('standard', response).map { |e|
        style_ids = e.xpath("x:styleId", 'x' => response.body.namespace.href).map(&:text)
        id = e.children.find { |e| e.name == "header" }.attributes["id"].value.to_i
        {
          "id" => id,
          "description" => e.children.find { |e| e.name == "description" }.text,
          "style_ids" => style_ids
        }
      }
    end

    def parse_engines(response)
      @engines = self.class.find_elements('engine', response).map do |e|
        Engine.new(e.at_xpath("x:engineType", 'x' => response.body.namespace.href).text)
      end
    end
  end
end
