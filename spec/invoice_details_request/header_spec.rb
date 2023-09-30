require 'spec_helper'

module CXML
  module InvoiceDetailRequest
    describe Header do
      it 'builds the header invoice detail request' do
        builder = Nokogiri::XML::Builder.new
        from_attrs = {
          role: 'from',
          name: 'Janice',
          email: 'janice@gmail.com',
          postal_address: {
            streets: ['1st Street'],
            city: 'Denver',
            postal_code: '1234',
            country: 'US',
            country_code: 'US'
          }
        }

        header = described_class.new(
          invoice_id: 1,
          invoice_date: '2016-10-15T15:48:51-00:00',
          from: from_attrs,
          bill_to: from_attrs.merge(role: 'billTo', name: 'Bill', email: 'bill@gmail.com'),
          remit_to: from_attrs.merge(role: 'remitTo', name: 'Bill', email: 'bill@gmail.com', address_id: '123'),
          payment_term: 30,
          primary_study_contact: 'John Doe',
          case_code: 'A1',
          vatin: '1234',
          comments: 'This is a credit memo',
          invoice_type: 'Credit Memo'
        )

        expect(header.render(builder).to_xml).to eq(<<~EOF
          <?xml version="1.0"?>
          <InvoiceDetailRequestHeader invoiceID="1" purpose="standard" operation="new" invoiceDate="2016-10-15T15:48:51-00:00">
            <InvoiceDetailHeaderIndicator/>
            <InvoiceDetailLineIndicator/>
            <InvoicePartner>
              <Contact role="from">
                <Name xml:lang="en">Janice</Name>
                <PostalAddress>
                  <Street>1st Street</Street>
                  <City>Denver</City>
                  <PostalCode>1234</PostalCode>
                  <Country isoCountryCode="US">US</Country>
                </PostalAddress>
                <Email>janice@gmail.com</Email>
              </Contact>
            </InvoicePartner>
            <InvoicePartner>
              <Contact role="billTo">
                <Name xml:lang="en">Bill</Name>
                <PostalAddress>
                  <Street>1st Street</Street>
                  <City>Denver</City>
                  <PostalCode>1234</PostalCode>
                  <Country isoCountryCode="US">US</Country>
                </PostalAddress>
                <Email>bill@gmail.com</Email>
              </Contact>
            </InvoicePartner>
            <InvoicePartner>
              <Contact role="remitTo" addressID="123">
                <Name xml:lang="en">Bill</Name>
                <PostalAddress>
                  <Street>1st Street</Street>
                  <City>Denver</City>
                  <PostalCode>1234</PostalCode>
                  <Country isoCountryCode="US">US</Country>
                </PostalAddress>
                <Email>bill@gmail.com</Email>
              </Contact>
            </InvoicePartner>
            <PaymentTerm payInNumberOfDays="30"/>
            <Comments xml:lang="en">This is a credit memo</Comments>
            <Extrinsic name="Primary Study Contact">John Doe</Extrinsic>
            <Extrinsic name="Case Code">A1</Extrinsic>
            <Extrinsic name="VATIN">1234</Extrinsic>
            <Extrinsic name="Invoice Type">Credit Memo</Extrinsic>
          </InvoiceDetailRequestHeader>
          EOF
        )
      end
    end
  end
end
