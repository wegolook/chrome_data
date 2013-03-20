require "net/http"
require "lolsoap"

module ChromeData
  class Base

    def initialize(attrs)
      attrs.each do |k, v|
        send "#{k}=", v
      end
    end

    class << self
      def request_name
        raise NotImplementedError, '#request_name should be implemented in subclass'
      end

      # Builds request, sets additional attributes on request element, makes request, and yields child elements from response to block
      def request(attributes, &blk)
        request = build_request

        request.body do |b|
          # Set configured account info on builder
          b.accountInfo(
            number: ChromeData.config.account_number,
            secret: ChromeData.config.account_secret,
            country: ChromeData.config.country,
            language: ChromeData.config.language
          )

          # Set additional elements on builder
          attributes.each do |k, v|
            b.__attribute__ k, v
          end
        end

        # Make the request
        response = make_request(request)

        # Find elements matching class name and yield them to the block
        response.body.xpath(".//x:#{name.split('::').last.downcase}", 'x' => response.body.namespace.href).map &blk
      end

      # Makes request, returns LolSoap::Response
      def make_request(request)
        raw_response = Net::HTTP.start(endpoint_uri.host, endpoint_uri.port) do |http|
          http.request_post(endpoint_uri.path, request.content, request.headers)
        end

        client.response(request, raw_response.body)
      end

      # Builds request, returns LolSoap::Request
      def build_request
        client.request request_name
      end

      def client
        @@client ||= LolSoap::Client.new(wsdl_body)
      end

      def wsdl_body
        @@wsdl_body ||= Net::HTTP.get_response(URI('http://services.chromedata.com/Description/7a?wsdl')).body
      end

      def endpoint_uri
        @@endpoint_uri ||= URI(client.wsdl.endpoint)
      end
    end

  end
end