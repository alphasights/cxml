require 'spec_helper'

module CXML
  module InvoiceDetailRequest
    describe ServiceItem do
      it 'builds the xml for service_items' do
        builder = CXML.builder

        segments_attrs = [
          { id: 405, name: 'Name', description: 'Description' },
          { id: 406, name: 'Other Name', description: 'Other Description' }
        ]
        distribution_attrs = {
          accounting_name: 'UK Account',
          accounting_segments: segments_attrs,
          charge_amount: 200,
          charge_currency: 'GBP'
        }

        item_attrs = {
          invoice_line_number: 1,
          reference_date: '2016-10-19T15:00:00-00:00',
          description: 'this is a description',
          amount: 400,
          currency: 'GBP',
          distributions: [distribution_attrs]
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
            <Distribution>
              <Accounting name="UK Account">
                <AccountingSegment id="405">
                  <Name xml:lang="en">Name</Name>
                  <Description xml:lang="en">Description</Description>
                </AccountingSegment>
                <AccountingSegment id="406">
                  <Name xml:lang="en">Other Name</Name>
                  <Description xml:lang="en">Other Description</Description>
                </AccountingSegment>
              </Accounting>
              <Charge>
                <Money currency="GBP">200</Money>
              </Charge>
            </Distribution>
          </InvoiceDetailServiceItem>
          EOF
        )
      end
    end
  end
end
