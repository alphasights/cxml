module CXML
  module InvoiceDetailRequest
    class Header
      attr_accessor :invoice_id, :operation, :purpose, :invoice_date, :remit_to, :bill_to, :payment_term

      def initialize(data={})
        if data.kind_of?(Hash) && !data.empty?
          @invoice_id = data['invoiceID']
          @operation = data.fetch('operation') { 'new' }
          @purpose = data.fetch('purpose') { 'standard' }
          @invoice_date = data['invoice_date']
          @remit_to = data['remitTo']['Contact']
          @bill_to = data['billTo']['Contact']
          @payment_term = data['PaymentTerm']
        end
      end

      def render(node)
        node.InvoiceDetailRequestHeader(
          'invoiceID' => invoice_id,
          'purpose' => purpose,
          'operation' => operation,
          'invoiceDate' => invoice_date
        ) do |h|
          node.InvoiceDetailHeaderIndicator
          node.InvoicePartner { |n| remit_to.render(n) }
          node.InvoicePartner { |n| bill_to.render(n) }
          node.PaymentTerm { |n| payment_term.render(n) }
        end
      end
    end
  end
end
