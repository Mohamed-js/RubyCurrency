require 'nokogiri'
require 'httparty'
require 'sinatra'

get '/' do
    original = HTTParty.get('https://www.cbe.org.eg/ar/EconomicResearch/Statistics/Pages/ExchangeRatesListing.aspx')
    parsed ||= Nokogiri::HTML(original.body)
    blocks = parsed.css('table.table tr')
    price = []
    blocks.each do |block|
        price = block.css('td').text.scan(/\d+/)[0..1] if block.css('td').text.start_with? 'دولار أمريكى'
    end
    content_type 'application/json'
    {dollar_equals: "#{price[0]}.#{price[1][0..1]}".to_f}.to_json
end