module ChromeData
  class Model < Base
    def styles
      Style.find_all_by_model_id id
    end

    class << self
      def find_all_by_year_and_division_id(year, division_id)
        request('modelYear' => year, 'divisionId' => division_id) do |model|
          new id: model.attributes['id'].value.to_i, name: model.text
        end
      end
    end

  end
end