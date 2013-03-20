module ChromeData
  class Division < Base
    def models_for_year(year)
      Model.find_all_by_year_and_division_id year, id
    end

    def self.find_all_by_year(year)
      request 'modelYear' => year
    end
  end
end