module CXML
  module InvoiceDetailRequest
    class Contact
      attr_accessor :role, :name, :language, :postal_address, :email

      def initialize(data={})
        if data.kind_of?(Hash) && !data.empty?
          @role = data['role']
          @name = data['Name']
          @email = data['Email']
          @postal_address =
            CXML::InvoiceDetailRequest::PostalAdress.new(data['PostalAddress'])
        end
      end

      def render(node)
        node.Contact('role' => role) do |c|
          c.Name(name, 'xm:lang' => 'en')
          c.Email(email, 'name'=> 'default')
          postal_address.render(c) if postal_address
        end
        node
      end
    end
  end
end
