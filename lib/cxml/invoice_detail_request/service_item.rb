module CXML
  module InvoiceDetailRequest
    class ServiceItem
      attr_accessor :invoice_line_number, :reference_date, :description, :amount, :currency, :distribution
      def initialize(data={})
        if data.kind_of?(Hash) && !data.empty?
          @invoice_line_number = data[:invoice_line_number]
          @reference_date = data[:reference_date]
          @description = data[:description]
          @amount = data[:amount]
          @currency = data[:currency]
          @distribution = CXML::InvoiceDetailRequest::Distribution.new(data[:distribution]) if data[:distribution]
        end
      end

      def render(node)
        node.InvoiceDetailServiceItem(
          'invoiceLineNumber' => invoice_line_number,
          'referenceDate' => reference_date) do |si|
            si.InvoiceDetailServiceItemReference do |sir|
              sir.Description(description, 'xml:lang' => 'en')
            end
            si.SubtotalAmount do |sa|
              sa.Money(amount, 'currency' => currency)
            end
            distribution.render(si) if distribution
          end
        node
      end
    end
  end
end
