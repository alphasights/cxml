require 'cxml/version'
require 'cxml/errors'
require 'time'
require 'nokogiri'

module CXML
  autoload :Protocol,      'cxml/protocol'
  autoload :Document,      'cxml/document'
  autoload :Header,        'cxml/header'
  autoload :Credential,    'cxml/credential'
  autoload :CredentialMac, 'cxml/credential_mac'
  autoload :Sender,        'cxml/sender'
  autoload :Status,        'cxml/status'
  autoload :Request,       'cxml/request'
  autoload :Response,      'cxml/response'
  autoload :Parser,        'cxml/parser'

  require 'cxml/invoice_detail_request/header'
  require 'cxml/invoice_detail_request/postal_address'
  require 'cxml/invoice_detail_request/contact'
  require 'cxml/invoice_detail_request/order'
  require 'cxml/invoice_detail_request/service_item'
  require 'cxml/invoice_detail_request/tax'
  require 'cxml/invoice_detail_request/summary'

  def self.parse(str)
    CXML::Parser.new.parse(str)
  end

  def self.builder
    Nokogiri::XML::Builder.new(:encoding => "UTF-8") do |xml|
      xml.doc.create_internal_subset('cXML', nil, "http://xml.cXML.org/schemas/cXML/1.2.020/InvoiceDetail.dtd")
    end
  end
end
