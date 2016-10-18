# Clients send requests for operations. Only one Request element is allowed for each 
# cXML envelope element, which simplifies the server implementations, because no 
# demultiplexing needs to occur when reading cXML documents. The Request element 
# can contain virtually any type of XML data.

module CXML
  class Request
    attr_accessor :id
    attr_accessor :deployment_mode
    attr_accessor :header
    attr_accessor :order
    attr_accessor :summary

    def initialize(data={})
      if data.kind_of?(Hash) && !data.empty?
        @id = data[:id]
        @deployment_mode = data[:deployment_mode]
        @header = CXML::InvoiceDetailRequest::Header.new(data[:header_attrs])
        @order = CXML::InvoiceDetailRequest::Order.new(data[:order_attrs])
        @summary = CXML::InvoiceDetailRequest::Summary.new(data[:summary_attrs])
      end
    end

    def render(node)
      node.Request('deploymentMode' => deployment_mode) do |request|
        request.InvoiceDetailRequest do |detail_request|
          header.render(detail_request)
          order.render(detail_request)
          summary.render(detail_request)
        end
      end
      node
    end
  end
end