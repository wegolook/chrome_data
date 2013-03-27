module ChromeData
  class Division < Base
    extend Parsers::Collection

    def models_for_year(year)
      Model.find_all_by_year_and_division_id year, id
    end

    def self.find_all_by_year(year)
      ChromeData.cache "get_divisions-model_year-#{year}" do
        request 'modelYear' => year
      end
    end
  end
end