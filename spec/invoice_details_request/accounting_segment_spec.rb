require 'spec_helper'

module CXML
  module InvoiceDetailRequest
    describe AccountingSegment do
      it 'builds an accounting segment of the distribution partial in the cxml invoice' do
        builder = CXML.builder
        data = { id: 405, name: 'Name', description: 'Description' }
        segment_object = described_class.new(data)

        expect(segment_object.render(builder).to_xml). to eq(<<~EOF
          <?xml version="1.0" encoding="UTF-8"?>
          <!DOCTYPE cXML SYSTEM "http://xml.cXML.org/schemas/cXML/1.2.020/InvoiceDetail.dtd">
          <AccountingSegment id="405">
            <Name xml:lang="en">Name</Name>
            <Description xml:lang="en">Description</Description>
          </AccountingSegment>
        EOF
      )
      end
    end
  end
end