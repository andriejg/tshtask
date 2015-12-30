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

  end
end
