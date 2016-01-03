require 'spec_helper'

describe Currency do

  describe ".statistics_hash" do

  	before do
  		(1..5).each do |x|
  		  FactoryGirl.create(:currency, buy_price: x, sell_price: x+1)
  		end
  	end

  	it "properly calculates statistics for buy_price" do
      buy_stats = Currency.statistics_hash('buy')
      expect(buy_stats[:max]).to eq 5.0
      expect(buy_stats[:min]).to eq 1.0
      expect(buy_stats[:average]).to eq 3.0
      expect(buy_stats[:median]).to eq 3.0
  	end

  	it "properly calculates statistics for sell_price" do
      sell_stats = Currency.statistics_hash('sell')
      expect(sell_stats[:max]).to eq 6.0
      expect(sell_stats[:min]).to eq 2.0
      expect(sell_stats[:average]).to eq 4.0
      expect(sell_stats[:median]).to eq 4.0
  	end
  end

  describe ".report_hash" do

  	before { @currency = FactoryGirl.create(:currency, name: 'test') }

  	it "generates hash with currency name and buy/sell statistics" do
  		raport = Currency.raport_hash
  		expect(raport[:name]).to eq 'test'
      expect(raport).to have_key(:buy_data)
      expect(raport).to have_key(:sell_data)
  	end
  end

  describe ".prices_hash" do
  	before do
  		@exchange1 = FactoryGirl.create(:exchange)
  		@exchange2 = FactoryGirl.create(:exchange)
  		FactoryGirl.create(:currency, 
  			buy_price: 12,
  			sell_price: 15,
  			exchange: @exchange1
  		)
  		FactoryGirl.create(:currency, 
  			buy_price: 14,
  			sell_price: 17,
  			exchange: @exchange2
  		)
  	end

	  it "has properly set buy prices" do
      buy_prices = Currency.prices_hash[:buy]
      expect(buy_prices.values[0]).to eq 12
      expect(buy_prices.values[1]).to eq 14
	  end

	  it "has properly set sell prices" do
      sell_prices = Currency.prices_hash[:sell]
      expect(sell_prices.values[0]).to eq 15
      expect(sell_prices.values[1]).to eq 17
	  end
  end
end
