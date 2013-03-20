module ChromeData
  class Division < Base
    attr_accessor :id, :name

    class << self
      def request_name
        'getDivisions'
      end

      def find_all_by_year(year)
        request('modelYear' => year) do |division|
          new id: division.attributes['id'].value, name: division.text
        end
      end
    end

  end
end