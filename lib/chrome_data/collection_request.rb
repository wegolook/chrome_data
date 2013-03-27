module ChromeData
  class CollectionRequest < BaseRequest
    attr_accessor :id, :name

    class << self
      def request_name
        # Cheap-o inflector
        "get#{name.split('::').last}s"
      end

      # Find elements matching class name and instantiate them using their id attribute and text
      def parse_response(response)
        find_elements(name.split('::').last.downcase, response).map do |e|
          new id: e.attributes['id'].value.to_i, name: e.text
        end
      end
    end
  end
end