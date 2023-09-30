require 'nokogiri'
module CXML
  module InvoiceDetailRequest
    class PostalAdress
      attr_accessor :streets, :city, :postal_code, :country, :country_code

      def initialize(data={})
        if data.kind_of?(Hash) && !data.empty?
          @streets = data['streets']
          @city = data['City']
          @postal_code = data['PostalCode']
          @country = data['Country']
          @country_code = data['isoCountryCode']
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
