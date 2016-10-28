require 'spec_helper'

describe CXML::Request do
  it 'creates the request partial for the cxml document' do
    builder = CXML.builder

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

    data = { 
      id: 1,
      deployment_mode: 'test',
      header_attrs:{
        invoice_id: 1,
        invoice_date: '2016-10-15T15:48:51-00:00',
        from: from_attrs,
        bill_to: from_attrs.merge(role: 'billTo', name: 'Bill', email: 'bill@gmail.com'),
        payment_term: 30,
        primary_study_contact: 'John Doe',
        case_code: 'A1',
        vatin: '1234',
        comments: 'This is an invoice'
        },
      order_attrs: {
        payload_id: 'TestAS1',
        items: [
          {
            invoice_line_number: 1,
            reference_date: '2016-10-19T15:00:00-00:00',
            description: 'this is a description',
            amount: 400,
            currency: 'GBP'
          },
          {
            invoice_line_number: 2,
            reference_date: '2016-10-19T15:00:00-00:00',
            description: 'this is a description',
            amount: 400,
            currency: 'GBP'
          }
        ]
      },
      summary_attrs: { 
        subtotal_amount: 2025,
        subtotal_currency: 'GBP',
        tax: { 
          tax_amount: '405',
          tax_currency: 'GBP',
          description: 'total tax',
          purpose: 'tax',
          category: 'vat',
          percentage_rate: '20',
          net_amount: 200,
          location: 'GB'
          },
          net_currency: 'GBP'
        }
    }
    request = described_class.new(data)

    expect(request.render(builder).to_xml).to eq(<<~EOF
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE cXML SYSTEM "http://xml.cXML.org/schemas/cXML/1.2.020/InvoiceDetail.dtd">
      <Request deploymentMode="test">
        <InvoiceDetailRequest>
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
            <PaymentTerm payInNumberOfDays="30"/>
            <Comments xml:lang="en">This is an invoice</Comments>
            <Extrinsic name="Primary Study Contact">John Doe</Extrinsic>
            <Extrinsic name="Case Code">A1</Extrinsic>
            <Extrinsic name="VATIN">1234</Extrinsic>
            <Extrinsic name="Invoice Type">Invoice</Extrinsic>
          </InvoiceDetailRequestHeader>
          <InvoiceDetailOrder>
            <InvoiceDetailOrderInfo>
              <MasterAgreementReference>
                <DocumentReference payloadID="TestAS1"/>
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
                <Money currency="GBP">400</Money>
              </SubtotalAmount>
            </InvoiceDetailServiceItem>
          </InvoiceDetailOrder>
          <InvoiceDetailSummary>
            <SubtotalAmount>
              <Money currency="GBP">2025</Money>
            </SubtotalAmount>
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
        </InvoiceDetailRequest>
      </Request>
    EOF
  )
  end
end
