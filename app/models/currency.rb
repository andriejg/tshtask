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

  def self.prices_hash
    prices = { buy: {}, sell: {} }
    all.each do |currency|
      prices[:buy][currency.exchange.created_at] = currency.buy_price
      prices[:sell][currency.exchange.created_at] = currency.sell_price
    end
    prices
  end
  
  def self.raport_hash
    {
      name: all.first.name,
      buy_data: all.statistics_hash('buy'),
      sell_data: all.statistics_hash('sell')
    }
  end

  def self.statistics_hash(action)
    prices = all.map(&"#{action}_price".to_sym).sort
    size = prices.size
    max = prices.max
    min = prices.min
    average = (prices.sum / size).round(4)
    median = (prices[(size - 1) / 2] + prices[size / 2]) / 2.0
    { max: max, min: min, average: average, median: median }
  end

end
