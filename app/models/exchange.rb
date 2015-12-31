class Exchange < ActiveRecord::Base
  require 'open-uri'

  attr_accessor :file

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
