module ChromeData
  class Style < Base
    extend Parsers::Collection

    def self.find_all_by_model_id(model_id)
      ChromeData.cache "get_styles-model_id-#{model_id}" do
        request 'modelId' => model_id
      end
    end
  end
end