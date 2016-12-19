module CXML
  module InvoiceDetailRequest
    class Distribution
      attr_accessor :accounting_name, :accounting_segments, :charge_amount, :charge_currency

      def initialize(data = {})
        if data.kind_of?(Hash) && !data.empty?
          @charge_amount = data[:charge_amount]
          @charge_currency = data[:charge_currency]
          @accounting_name = data[:accounting_name]
          @accounting_segments = data[:accounting_segments].to_a.map do |args|
            CXML::InvoiceDetailRequest::AccountingSegment.new(args)
          end
        end
      end

      def render(node)
        node.Distribution do |distribution|
          distribution.Accounting('name' => accounting_name) do |accounting|
            accounting_segments.each {|segment| segment.render(accounting) }
          end
          distribution.Charge do |charge|
            charge.Money(charge_amount, 'currency' => charge_currency)
          end
        end
        node
      end
    end
  end
end