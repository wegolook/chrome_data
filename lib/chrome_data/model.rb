module ChromeData
  class Model < Base
    def styles
      Style.find_all_by_model_id id
    end

    def self.find_all_by_year_and_division_id(year, division_id)
      request 'modelYear' => year, 'divisionId' => division_id
    end
  end
end