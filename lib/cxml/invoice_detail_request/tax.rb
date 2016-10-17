module CXML
  module InvoiceDetailRequest
    class Tax
      attr_accessor :amount, :currency, :description, :purpose, :category, :percentage_rate, :location
      def initialize(data = {})
        @amount = data[:amount]
        @currency = data[:currency]
        @description = data[:description]
        @purpose = data[:purpose]
        @category = data[:category]
        @percentage_rate = data[:percentage_rate]
        @location = data[:location]
      end

      def render(node)
        node.Tax do |t|
          t.Money(amount, 'currency' => currency)
          t.Description(description, 'xml:lang' => 'en')
          t.TaxDetail( 'purpose' => purpose, 'category' => category, 'percentageRate' => percentage_rate) do |td|
            td.TaxAmount do |ta|
              ta.Money(amount, 'currency' => currency)
            end
            td.TaxLocation(location, 'xml:lang' => 'en')
          end
        end
        node
      end
    end
  end
end