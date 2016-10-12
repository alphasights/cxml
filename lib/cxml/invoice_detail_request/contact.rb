module CXML
  module InvoiceDetailRequest
    class Contact
      attr_accessor :role, :address_id, :name, :language, :postal_address, :email

      def initialize(data={})
        if data.kind_of?(Hash) && !data.empty?
          @role = data['role']
          @address_id = data['addressID']
          @name = data['Name']
          @email = data['Email']
          @postal_address =
            CXML::InvoiceDetailRequest::PostalAdress.new(data['PostalAddress'])
        end
      end

      def render(node)
        node.Contact(contact_attributes) do |c|
          c.Name(name, 'xm:lang' => 'en')
          c.Email(email, 'name'=> 'default')

          postal_address.render(c) if postal_address
        end
        node
      end

      private

      def contact_attributes
        { 'role' => role }.tap do |ca|
          ca['addressID'] = address_id if address_id
        end
      end
    end
  end
end
