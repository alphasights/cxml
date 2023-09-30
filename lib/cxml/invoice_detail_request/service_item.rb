module CXML
  module InvoiceDetailRequest
    class ServiceItem
      attr_accessor :invoice_line_number, :reference_date, :description, :amount, :currency, :distributions
      def initialize(data={})
        if data.kind_of?(Hash) && !data.empty?
          @invoice_line_number = data[:invoice_line_number]
          @reference_date = data[:reference_date]
          @description = data[:description]
          @amount = data[:amount]
          @currency = data[:currency]
          @distributions = data[:distributions].to_a.map do |args|
            CXML::InvoiceDetailRequest::Distribution.new(args)
          end
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
            distributions.each do |distribution|
              distribution.render(si)
            end
          end
        node
      end
    end
  end
end
