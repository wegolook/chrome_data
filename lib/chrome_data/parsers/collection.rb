module ChromeData::Parsers
  module Collection

    # Find elements matching class name and instantiate them using their id attribute and text
    def parse_response(response)
      response.body.xpath(".//x:#{name.split('::').last.downcase}", 'x' => response.body.namespace.href).map do |e|
        new id: e.attributes['id'].value.to_i, name: e.text
      end
    end

  end
end