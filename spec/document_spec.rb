require 'spec_helper'

describe CXML::Document do
  describe '#render' do
    it 'creates a cxml document' do
      data = {
        version: 1,
        payload_id: 2,
        timestamp: "2016-09-30 00:00:00 +0100",
        header:{
          from: {
            credential: {
              domain: 'NetworkID',
              identity: 'alpha1'
            }
          },
          to: {
            credential: {
              domain: 'NetworkID',
              identity: 'alpha-client'
            }
          },
          sender: {
            credential: {
              domain: 'NetworkID',
              identity: 'alpha1',
              shared_secret: 'welcome'
            },
            user_agent: 'alpha'
          }
        },
        request:{
          id: 1,
          deployment_mode: 'test',
          header_attrs:{
            invoice_id: 1,
            invoice_date: '2016-10-15T15:48:51-00:00',
            from: {
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
            },
            bill_to: {
              role: 'billTo',
              name: 'Bill',
              email: 'bill@gmail.com',
              postal_address: {
                streets: ['1st Street'],
                city: 'Denver',
                postal_code: '1234',
                country: 'US',
                country_code: 'US'
              }
            },
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
      }
      doc = nil

      expect { doc = CXML::Document.new(data) }.not_to raise_error

      doc.payload_id.should_not be_nil
      doc.timestamp.should be_a Time

      doc.header.should be_a CXML::Header
      doc.request.should be_a CXML::Request
      doc.response.should be_nil

      expect { doc.render }.not_to raise_error
      expect(doc.render.to_xml).to eq(<<~EOF
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE cXML SYSTEM "http://xml.cXML.org/schemas/cXML/1.2.020/InvoiceDetail.dtd">
        <cXML payloadID="2" timestamp="2016-09-30T00:00:00+01:00">
          <Header>
            <From>
              <Credential domain="NetworkID">
                <Identity>alpha1</Identity>
              </Credential>
            </From>
            <To>
              <Credential domain="NetworkID">
                <Identity>alpha-client</Identity>
              </Credential>
            </To>
            <Sender>
              <Credential domain="NetworkID">
                <Identity>alpha1</Identity>
                <SharedSecret>welcome</SharedSecret>
              </Credential>
              <UserAgent>alpha</UserAgent>
            </Sender>
          </Header>
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
        </cXML>
      EOF
      )
    end
  end
end
