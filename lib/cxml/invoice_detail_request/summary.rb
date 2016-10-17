module CXML
  module InvoiceDetailRequest
    class Summary
      attr_accessor :subtotal_amount, :subtotal_currency, :tax_amount, :tax, :net_currency
      def initialize(data = {})
        if data.kind_of?(Hash) && !data.empty?
          @subtotal_amount = subtotal_amount
          @subtotal_currency = subtotal_currency
          @tax = CXML::InvoiceDetailRequest::Tax.new(data[:tax])
          @net_currency = data[:net_currency]
        end
      end

      def render(node)
        node.Summary do |summary|
          summary.SubtotalAmount do |sub|
            sub.Money(subtotal_amount, 'currency' => subtotal_currency)
          end
          tax.render(summary)
          summary.NetAmount do |net|
            net.Money('currency' => net_currency)
          end
        end
      end
    end
  end
end
