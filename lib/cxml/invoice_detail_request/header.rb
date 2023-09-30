module CXML
  module InvoiceDetailRequest
    class Header
      attr_accessor :invoice_id, :operation, :purpose, :invoice_date, :from, :bill_to, :remit_to,
        :payment_term, :primary_study_contact, :case_code, :vatin, :comments, :invoice_type

      def initialize(data={})
        if data.kind_of?(Hash) && !data.empty?
          @invoice_id = data[:invoice_id]
          @operation = data[:operation]
          @purpose = data[:purpose]
          @invoice_date = data[:invoice_date]
          @from = CXML::InvoiceDetailRequest::Contact.new(data[:from])
          @bill_to = CXML::InvoiceDetailRequest::Contact.new(data[:bill_to])
          @remit_to = CXML::InvoiceDetailRequest::Contact.new(data[:remit_to])
          @payment_term = data[:payment_term]
          @comments = data[:comments]
          @primary_study_contact = data[:primary_study_contact]
          @case_code = data[:case_code]
          @vatin = data[:vatin]
          @invoice_type = data[:invoice_type]
        end
      end

      def render(node)
        node.InvoiceDetailRequestHeader(
          'invoiceID' => invoice_id,
          'purpose' => purpose || 'standard',
          'operation' => operation || 'new',
          'invoiceDate' => invoice_date
        ) do |h|
          h.InvoiceDetailHeaderIndicator
          h.InvoiceDetailLineIndicator
          h.InvoicePartner { |n| from.render(n) }
          h.InvoicePartner { |n| bill_to.render(n) }
          h.InvoicePartner { |n| remit_to.render(n) }
          h.PaymentTerm('payInNumberOfDays' => payment_term)
          h.Comments(comments, 'xml:lang' => 'en') if comments
          h.Extrinsic(primary_study_contact, 'name' => 'Primary Study Contact') if primary_study_contact
          h.Extrinsic(case_code, 'name' => 'Case Code') if case_code
          h.Extrinsic(vatin, 'name' => 'VATIN') if vatin
          h.Extrinsic(invoice_type, 'name' => 'Invoice Type') if invoice_type
        end
        node
      end
    end
  end
end
