module ChromeData
  class Division < Base
    attr_accessor :id, :name

    def models_for_year(year)
      Model.find_all_by_year_and_division_id year, id
    end

    class << self
      def request_name
        'getDivisions'
      end

      def find_all_by_year(year)
        request('modelYear' => year) do |division|
          new id: division.attributes['id'].value.to_i, name: division.text
        end
      end
    end

  end
end