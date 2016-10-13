module CXML
  module InvoiceDetailRequest
    class Header
      attr_accessor :invoice_id, :operation, :purpose, :invoice_date, :from, :bill_to,
        :payment_term, :primary_study_contact, :case_code, :vatin

      def initialize(data={})
        if data.kind_of?(Hash) && !data.empty?
          @invoice_id = data['invoiceID']
          @operation = data.fetch('operation') { 'new' }
          @purpose = data.fetch('purpose') { 'standard' }
          @invoice_date = data['invoice_date']
          @from = data['from']['Contact']
          @bill_to = data['billTo']['Contact']
          @payment_term = data['PaymentTerm']
          @primary_study_contact = data['primary_study_contact']
          @case_code = data['case_code']
          @vatin = data['vatin']
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
          node.InvoiceDetailLineIndicator
          node.InvoicePartner { |n| from.render(n) }
          node.InvoicePartner { |n| bill_to.render(n) }
          node.PaymentTerm('payInNumberOfDays' => payment_term)
          node.Extrinsic(primary_study_contact, 'name' => primary_study_contact) if primary_study_contact
          node.Extrinsic(case_code, 'name' => case_code) if case_code
          node.Extrinsic(vatin, 'name' => vatin) if vatin
        end
        node
      end
    end
  end
end
