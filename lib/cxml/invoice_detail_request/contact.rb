module CXML
  module InvoiceDetailRequest
    class Contact
      attr_accessor :role, :name, :language, :postal_address, :email

      def initialize(data={})
        if data.kind_of?(Hash) && !data.empty?
          @role = data[:role]
          @name = data[:name]
          @email = data[:email]
          @postal_address =
            CXML::InvoiceDetailRequest::PostalAddress.new(data[:postal_address])
        end
      end

      def render(node)
        node.Contact('role' => role) do |c|
          c.Name(name, 'xml:lang' => 'en')
          postal_address.render(c) if postal_address
          c.Email(email)
        end
        node
      end
    end
  end
end
