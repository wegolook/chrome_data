require "net/http"
require "lolsoap"

module ChromeData
  class BaseRequest
    def initialize(attrs={})
      attrs.each do |k, v|
        send "#{k}=", v
      end
    end

    class << self
      # Builds request, sets additional data on request element, makes request,
      # and returns array of child elements wrapped in instances of this class
      def request(data)
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
          data.each do |k, v|
            # Add the key/value pair as an attribute to the request element if that's what it should be,
            # otherwise add it as a sub-element
            # NOTE: This basically mirrors LolSoap::Builder#method_missing
            #       because Builder undefines most methods, including #send

            # allow arrays of values, as well as simple values
            ((v.kind_of? Array) ? v : Array(v)).each do |single_v|
              if b.__type__.has_attribute?(k)
                b.__attribute__ k, single_v
              else
                b.__tag__ k, single_v
              end
            end
          end
        end

        # Make the request
        response = make_request(request)

        parse_response(response)
      end

      # Makes request, returns LolSoap::Response
      def make_request(request)
        raw_response = Net::HTTP.start(endpoint_uri.host, endpoint_uri.port) do |http|
          http.request_post(endpoint_uri.path, request.content, request.headers)
        end

        response = client.response(request, raw_response.body)

        # Sometimes Chrome sends a 500 with a valid SOAP fault in it, sometimes we see a 503 with a html
        # message in the body.  In the first case, the above line will raise a LOLSoapFault.  If we get
        # here, there was some other HTTP error, so raise that.
        raw_response.value    # raises HTTP exception if not a 2xx response

        response
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

      # Given an element_name and LolSoap::Response, returns an array of Nokogiri::XML::Elements
      def find_elements(element_name, response)
        response.body.xpath(".//x:#{element_name}", 'x' => response.body.namespace.href)
      end

      # Internal: Given a LolSoap::Response, returns appropriately parsed response
      def parse_response(response)
        raise NotImplementedError, '.parse_response should be implemented in subclass'
      end

      def request_name
        raise NotImplementedError, '.request_name should be implemented in subclass'
      end
    end
  end
end
