require 'spec_helper'

describe CXML::Sender do
  describe "#render" do
    it "returns cxml sender field" do
      builder = CXML.builder
      sender_credential = CXML::Credential.new
      sender_credential.domain = 'sender_domain'
      sender_credential.identity = 'sender_id'
      sender_credential.shared_secret = "123456"

      sender = described_class.new      
      sender.user_agent = 'Alphasights LTD'
      sender.credential = sender_credential

      expect(sender.render(builder).to_xml).to eq(<<~EOF
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE cXML SYSTEM "http://xml.cXML.org/schemas/cXML/1.2.020/InvoiceDetail.dtd">
        <Sender>
          <Credential domain="sender_domain">
            <Identity>sender_id</Identity>
            <SharedSecret>123456</SharedSecret>
          </Credential>
          <UserAgent>Alphasights LTD</UserAgent>
        </Sender>
        EOF
      )
      
    end
  end
end