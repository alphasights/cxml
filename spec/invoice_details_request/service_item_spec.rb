require 'spec_helper'

module CXML
  module InvoiceDetailRequest
    describe ServiceItem do
      it 'builds the xml for service_items' do
        builder = CXML.builder
        item_attrs = {
          invoice_line_number: 1,
          reference_date: '2016-10-19T15:00:00-00:00',
          description: 'this is a description',
          amount: 400,
          currency: 'GBP'
        }

        service_item = described_class.new(item_attrs)

        expect(service_item.render(builder).to_xml).to eq(<<~EOF
          <?xml version="1.0" encoding="UTF-8"?>
          <!DOCTYPE cXML SYSTEM "http://xml.cXML.org/schemas/cXML/1.2.020/InvoiceDetail.dtd">
          <InvoiceDetailServiceItem invoiceLineNumber="1" referenceDate="2016-10-19T15:00:00-00:00">
            <InvoiceDetailServiceItemReference>
              <Description xml:lang="en">this is a description</Description>
            </InvoiceDetailServiceItemReference>
            <SubtotalAmount>
              <Money currency="GBP">400</Money>
            </SubtotalAmount>
          </InvoiceDetailServiceItem>
          EOF
        )
      end
    end
  end
end
