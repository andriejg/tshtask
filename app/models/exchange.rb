class Exchange < ActiveRecord::Base
  has_many :currencies

  require 'open-uri'

  attr_accessor :file
  
  paginates_per 10

  def self.get_new_rates
    exchange = Exchange.new
    exchange.get_nbp_xml
    exchange.save_current_rates
  end

  def get_nbp_xml
  	open('lastc.xml', 'wb') do |file|
      file << open('http://www.nbp.pl/kursy/xml/lastc.xml').read
      self.file = file
    end
  end

  def save_current_rates
  	xml = Nokogiri::XML(File.open(file)) { |config| config.strict.noblanks }
  	self.name = xml.xpath("//numer_tabeli")[0].inner_text
    if Exchange.last.nil? || Exchange.last.name != self.name
  		self.save
  	  xml.xpath("//pozycja").each { |node| Currency.create_from_node(node, self) }
  	end
  end

end
