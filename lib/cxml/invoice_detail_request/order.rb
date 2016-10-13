module CXML
  module InvoiceDetailRequest
    class Order
      attr_accessor :payload_id, :items

      def intialize(data={})
        if data.kind_of?(Hash) && !data.empty?
          @payload_id = data['payloadID']
          @items = data['items']
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
      end
    end
  end
end
