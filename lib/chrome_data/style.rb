module ChromeData
  class Style < Base
    class << self
      def request_name
        'getStyles'
      end

      def find_all_by_model_id(model_id)
        request('modelId' => model_id) do |style|
          new id: style.attributes['id'].value.to_i, name: style.text
        end
      end
    end

  end
end