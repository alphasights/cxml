require 'spec_helper'

module CXML
  module InvoiceDetailRequest
    describe Order do
      it 'builds the body of the invoice' do
        builder = CXML.builder
        item_1 = {
          invoice_line_number: 1,
          reference_date: '2016-10-19T15:00:00-00:00',
          description: 'this is a description',
          amount: 400,
          currency: 'GBP'
        }
        item_2 = item_1.merge(invoice_line_number: 2, amount: 200)

        order = described_class.new(payload_id: 'test', items: [item_1, item_2])

        expect(order.render(builder).to_xml).to eq(<<~EOF
          <?xml version="1.0" encoding="UTF-8"?>
          <InvoiceDetailOrder>
            <InvoiceDetailOrderInfo>
              <MasterAgreementReference>
                <DocumentReference payloadID="test"/>
              </MasterAgreementReference>
            </InvoiceDetailOrderInfo>
            <InvoiceDetailServiceItem invoiceLineNumber="1" referenceDate="2016-10-19T15:00:00-00:00">
              <InvoiceDetailServiceItemReference>
                <Description xml:lang="en">this is a description</Description>
              </InvoiceDetailServiceItemReference>
              <SubtotalAmount>
                <Money currency="GBP">400</Money>
              </SubtotalAmount>
            </InvoiceDetailServiceItem>
            <InvoiceDetailServiceItem invoiceLineNumber="2" referenceDate="2016-10-19T15:00:00-00:00">
              <InvoiceDetailServiceItemReference>
                <Description xml:lang="en">this is a description</Description>
              </InvoiceDetailServiceItemReference>
              <SubtotalAmount>
                <Money currency="GBP">200</Money>
              </SubtotalAmount>
            </InvoiceDetailServiceItem>
          </InvoiceDetailOrder>
          EOF
        )
      end
    end
  end
end
