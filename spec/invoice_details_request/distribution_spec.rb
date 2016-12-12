require 'spec_helper'

module CXML
  module InvoiceDetailRequest
    describe Distribution do
      it 'builds a distribution partial in the cxml invoice' do
        builder = CXML.builder
        segments_data = [
          { id: 405, name: 'Name', description: 'Description' },
          { id: 406, name: 'Other Name', description: 'Other Description' }
        ]
        data = { accounting_name: 'UK Account', accounting_segments: segments_data, charge_amount: 200, charge_currency: 'GBP' }
        distribution_object = described_class.new(data)

        expect(distribution_object.render(builder).to_xml). to eq(<<~EOF
          <?xml version="1.0" encoding="UTF-8"?>
          <!DOCTYPE cXML SYSTEM "http://xml.cXML.org/schemas/cXML/1.2.020/InvoiceDetail.dtd">
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
        EOF
      )
      end
    end
  end
end