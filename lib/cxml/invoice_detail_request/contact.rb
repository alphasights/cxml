module CXML
  module InvoiceDetailRequest
    class Contact
      attr_accessor :role, :name, :language, :postal_address, :email,
        :primary_study_contact, :case_code, :vatin, :payment_term

      def initialize(data={})
        if data.kind_of?(Hash) && !data.empty?
          @role = data['role']
          @name = data['Name']
          @email = data['Email']
          @payment_term = data['PaymentTerm']
          @primary_study_contact = data['primary_study_contact']
          @case_code = data['case_code']
          @vatin = data['vatin']
          @postal_address =
            CXML::InvoiceDetailRequest::PostalAdress.new(data['PostalAddress'])
        end
      end

      def render(node)
        node.Contact('role' => role) do |c|
          c.Name(name, 'xm:lang' => 'en')
          c.Email(email, 'name'=> 'default')
          c.PaymentTerm('payInNumberOfDays' => payment_term)
          c.Extrinsic(primary_study_contact, 'name' => primary_study_contact) if primary_study_contact
          c.Extrinsic(case_code, 'name' => case_code) if case_code
          c.Extrinsic(vatin, 'name' => vatin) if vatin

          postal_address.render(c) if postal_address
        end
        node
      end
    end
  end
end
