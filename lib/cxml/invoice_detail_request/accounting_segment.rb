module CXML
  module InvoiceDetailRequest
    class AccountingSegment
      attr_accessor :id, :name, :description

      def initialize(data = {})
        if data.kind_of?(Hash) && !data.empty?
          @id = data[:id]
          @name = data[:name]
          @description = data[:description]
        end
      end

      def render(node)
        node.AccountingSegment('id' => id) do |segment|
          segment.Name(name, 'xml:lang' => 'en')
          segment.Description(description, 'xml:lang' => 'en')
        end
        node
      end
    end
  end
end