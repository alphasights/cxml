module CXML
  class Document
    attr_accessor :version
    attr_accessor :payload_id
    attr_accessor :timestamp

    attr_accessor :header
    attr_accessor :request
    attr_accessor :response

    def initialize(data={})
      if data.kind_of?(Hash) && !data.empty?
        @version = data[:version]
        @payload_id = data[:payload_id]

        if data[:timestamp]
          @timestamp = Time.parse(data[:timestamp])
        end

        if data[:header]
          @header = CXML::Header.new(data[:header])
        end

        if data[:request]
          @request = CXML::Request.new(data[:request])
        end

        if data[:response]
          @response = CXML::Response.new(data[:response])
        end
      end
    end

    def setup
      @version    = CXML::Protocol.version
      @timestamp  = Time.now.utc
      @payload_id = "#{@timestamp.to_i}.process.#{Process.pid}@domain.com"
    end

    # Check if document is request
    # @return [Boolean]
    def request?
      !request.nil?
    end

    # Check if document is a response
    # @return [Boolean]
    def response?
      !response.nil?
    end

    def render
      node = CXML.builder
      node.cXML('payloadID' => payload_id, 'timestamp' => timestamp.iso8601) do |doc|
        doc.Header { |n| @header.render(n) } if @header
        @request.render(node) if @request
        @response.render(node) if @response
      end
      node
    end
  end
end