require 'byebug'

module CXML
  module InvoiceDetailRequest
    class Contact
      attr_accessor :role, :name, :language, :postal_address, :email, :address_id

      def initialize(data={})
        if data.kind_of?(Hash) && !data.empty?
          @role = data[:role]
          @name = data[:name]
          @email = data[:email]
          @address_id = data[:address_id]
          @postal_address =
            CXML::InvoiceDetailRequest::PostalAddress.new(data[:postal_address])
        end
      end

      def render(node)
        contact_args = { 'role' => role }
        contact_args = contact_args.merge('addressID' => address_id) if address_id
        node.Contact(contact_args) do |c|
          c.Name(name, 'xml:lang' => 'en')
          postal_address.render(c) if postal_address
          c.Email(email) if email
        end
        node
      end
    end
  end
end
