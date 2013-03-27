module ChromeData
  class Model < Base
    extend Parsers::Collection

    def styles
      Style.find_all_by_model_id id
    end

    def self.find_all_by_year_and_division_id(year, division_id)
      ChromeData.cache "#{request_name.underscore}-model_year-#{year}-division_id-#{division_id}" do
        request 'modelYear' => year, 'divisionId' => division_id
      end
    end
  end
end