module ChromeData
  class Style < Base
    attr_accessor :id, :name

    class << self
      def request_name
        'getStyles'
      end

      def find_all_by_model_id(model_id)
        request('modelId' => model_id) do |style|
          new id: style.attributes['id'].value, name: style.text
        end
      end
    end

  end
end