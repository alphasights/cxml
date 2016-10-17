require 'spec_helper'

module CXML
  module InvoiceDetailRequest
    describe Tax do
      it 'builds the tax partial of the cxml invoice' do 
        builder = CXML.builder
        data = { amount: 405, currency: 'GBP', description: "total tax", purpose: "tax",
          category: "vat", percentage_rate: "20", location: 'GB' }
        tax_object = described_class.new(data)

        expect(tax_object.render(builder).to_xml). to eq(<<~EOF
          <?xml version="1.0" encoding="UTF-8"?>
          <!DOCTYPE cXML SYSTEM "http://xml.cXML.org/schemas/cXML/1.2.020/InvoiceDetail.dtd">
          <Tax>
            <Money currency="GBP">405</Money>
            <Description xml:lang="en">total tax</Description>
            <TaxDetail purpose="tax" category="vat" percentageRate="20">
              <TaxAmount>
                <Money currency="GBP">405</Money>
              </TaxAmount>
              <TaxLocation xml:lang="en">GB</TaxLocation>
            </TaxDetail>
          </Tax>
        EOF
      )
      end
    end
  end
end