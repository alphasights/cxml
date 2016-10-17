module CXML
  module InvoiceDetailRequest
    class Order
      attr_accessor :payload_id, :items

      def initialize(data={})
        if data.kind_of?(Hash) && !data.empty?
          @payload_id = data[:payload_id]
          @items = data[:items].map do |args|
            CXML::InvoiceDetailRequest::ServiceItem.new(args)
          end
        end
      end

      def render(node)
        node.InvoiceDetailOrder do |o|
          o.InvoiceDetailOrderInfo do |oi|
            oi.MasterAgreementReference do |mar|
              mar.DocumentReference('payloadID' => payload_id)
            end
          end

          items.each do |item|
            item.render(o)
          end
        end
        node
      end
    end
  end
end
