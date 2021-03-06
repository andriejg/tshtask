class MoneyController < ApplicationController
  before_action :authenticate_user!

  #show list of exchange rates with creation time
  #don't forget about pagination
  def index
    @exchanges = Exchange.all.reverse_order.page(params[:page])
  end

  #show table of currencies for selected exchange rate
  def show
    @exchange = Exchange.find(params[:id])
  end

  #for manual refreshing
  #get latest exchange rates and save to db
  #can be helpful: 
  #http://www.nbp.pl/home.aspx?f=/kursy/instrukcja_pobierania_kursow_walut.html
  def refresh_rates
    Exchange.get_new_rates
    redirect_to :back, alert: 'Downloaded exchange rates'
  end

  #generate a report for selected currency
  #report should show: basic statistics: mean, median, average
  #also You can generate a simple chart(use can use some js library)
  
  #this method should be available only for currencies which exist in the database 
  def report
    currency = Currency.where(code: params[:money_id])
    unless currency.empty?
      @currency_hash = currency.raport_hash
      @chart_prices = currency.prices_hash
      @exchange = params[:exchange]
    else
      redirect_to money_index_path, alert: 'Wrong currency'
    end
  end


end
