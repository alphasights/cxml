require 'spec_helper'

module CXML
  module InvoiceDetailRequest
    describe Summary do
      it 'builds the summary of the cxml invoice' do
        builder = CXML.builder
        data = { subtotal_amount: 2025, subtotal_currency: 'GBP', tax_amount: 405, tax_currency: 'GBP',
          tax: { tax_amount: '405', tax_currency: 'GBP', description: 'total tax', purpose: 'tax', category: 'vat', percentage_rate: '20', net_amount: 200, location: 'GB' },
          net_currency: 'GBP' }
        summary = described_class.new(data)
        expect(summary.render(builder).to_xml).to eq(<<~EOF
          <?xml version="1.0" encoding="UTF-8"?>
          <!DOCTYPE cXML SYSTEM "http://xml.cXML.org/schemas/cXML/1.2.020/InvoiceDetail.dtd">
          <InvoiceDetailSummary>
            <SubtotalAmount>
              <Money currency="GBP">2025</Money>
            </SubtotalAmount>
            <InvoiceDetailDiscount>
              <Money currency="GBP">500</Money>
            </InvoiceDetailDiscount>
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
            <NetAmount>
              <Money currency="GBP"/>
            </NetAmount>
          </InvoiceDetailSummary>
        EOF
      )
      end
    end
  end
end