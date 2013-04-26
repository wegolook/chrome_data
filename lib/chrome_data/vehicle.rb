module ChromeData
  class Vehicle < BaseRequest
    class Engine < Struct.new(:type); end

    attr_accessor :model_year, :division, :model, :styles, :engines

    class << self
      def request_name
        "describeVehicle"
      end

      def find_by_vin(vin)
        request 'vin' => vin
      end

      def parse_response(response)
        if vin_description = find_elements('vinDescription', response).first
          new.tap do |v|
            v.model_year = vin_description.attr('modelYear').to_i
            v.division = vin_description.attr('division')
            v.model = vin_description.attr('modelName')

            v.styles = find_elements('style', response).map do |e|
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

            v.engines = find_elements('engine', response).map do |e|
              Engine.new(e.at_xpath("x:engineType", 'x' => response.body.namespace.href).text)
            end
          end
        end
      end
    end
  end
end