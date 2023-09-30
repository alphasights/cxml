require 'spec_helper'

module CXML
  module InvoiceDetailRequest
    describe Contact do
      it 'builds a contact as cxml' do
        builder = Nokogiri::XML::Builder.new
        address = PostalAddress.new(
          streets: ['1st street'],
          city: 'New York',
          postal_code: '1234',
          country: 'USA',
          country_code: 'US'
        )

        contact = described_class.new(
          role: 'from',
          name: 'John Doe',
          email: 'jd@gmail.com',
        )
        contact.postal_address = address

        expect(contact.render(builder).to_xml).to eq(<<~EOF
          <?xml version="1.0"?>
          <Contact role="from">
            <Name xml:lang="en">John Doe</Name>
            <PostalAddress>
              <Street>1st street</Street>
              <City>New York</City>
              <PostalCode>1234</PostalCode>
              <Country isoCountryCode="US">USA</Country>
            </PostalAddress>
            <Email>jd@gmail.com</Email>
          </Contact>
          EOF
        )
      end
    end
  end
end
