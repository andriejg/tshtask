class MoneyController < ApplicationController
  before_action :authenticate_user!, only: [:refresh_rates]

  #show list of exchange rates with creation time
  #don't forget about pagination
  def index
    @exchanges = Exchange.page(params[:page])
  end

  def show
    #show table of currencies for selected exchange rate
  end

  #for manual refreshing
  #get latest exchange rates and save to db
  #can be helpful: 
  #http://www.nbp.pl/home.aspx?f=/kursy/instrukcja_pobierania_kursow_walut.html
  def refresh_rates
    exchange = Exchange.new
    exchange.get_nbp_xml
    exchange.save_current_rates
    redirect_to :back, alert: 'Downloaded exchange rates'
  end

  def report
    #generate a report for selected currency
    #report should show: basic statistics: mean, median, average
    #also You can generate a simple chart(use can use some js library)

    #this method should be available only for currencies which exist in the database 
  end


end
