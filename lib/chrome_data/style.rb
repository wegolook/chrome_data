module ChromeData
  class Style < Base
    def self.find_all_by_model_id(model_id)
      request 'modelId' => model_id
    end
  end
end