require 'nokogiri'
require 'pry'
module CXML
  module InvoiceDetailRequest
    class PostalAddress
      attr_accessor :streets, :city, :postal_code, :country, :country_code

      def initialize(data={})
        if data.kind_of?(Hash) && !data.empty?
          @streets = data[:streets]
          @city = data[:city]
          @postal_code = data[:postal_code]
          @country = data[:country]
          @country_code = data[:country_code]
        end
      end

      def render(node)
        node.PostalAddress do |pa|
          streets.each do |street|
            pa.Street(street)
          end
          pa.City(city)
          pa.PostalCode(postal_code)
          pa.Country(country, 'isoCountryCode' => country_code)
        end
      end
    end
  end
end
