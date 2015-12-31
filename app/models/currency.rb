class Currency < ActiveRecord::Base
  belongs_to :exchange

  def self.create_from_node(node, exchange)
  	Currency.create(
  	  name: node.xpath("nazwa_waluty").inner_text,
  	  converter: node.xpath("przelicznik").inner_text,
  	  code: node.xpath("kod_waluty").inner_text,
  	  buy_price: node.xpath("kurs_kupna").inner_text.gsub(',','.').to_f,
  	  sell_price: node.xpath("kurs_sprzedazy").inner_text.gsub(',','.').to_f,
  	  exchange: exchange
  	)
  end
  
end
