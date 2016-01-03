require 'spec_helper'

describe MoneyController do

  before (:each) do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  describe "GET 'index'" do
    
    it "should render :index" do
      get :index
      expect(response).to render_template(:index)
    end

    context "assigns @exchanges with pagination" do

      before do
        @other_exchange = FactoryGirl.create(:exchange)
        @exchanges = []
        10.times { @exchanges << FactoryGirl.create(:exchange) }
      end

      it "with reverse order for the first page" do
        get :index
        expect(assigns(:exchanges)).to match_array @exchanges
      end

      it "with reverse order for the second page" do
        get :index, page: 2
        expect(assigns(:exchanges)).to contain_exactly @other_exchange
      end
    end

    context "for unlogged user" do
      it "does not render index" do
        sign_out @user
        get :index
        expect(response).not_to render_template(:index)
      end
    end
  end
  
  describe "GET 'show'" do

    before(:each) { @exchange = FactoryGirl.create(:exchange) }

    it "should render :show" do
      get :show, id: @exchange.id
      expect(response).to render_template(:show)
    end

    it "assigns @exchange" do
      get :show, id: @exchange.id
      expect(assigns(:exchange)).to eq @exchange
    end
  end

  describe "GET 'refresh_rates'" do
    
    before { request.env["HTTP_REFERER"] = "test_back" }

    it "redirects back" do
      get :refresh_rates
      expect(response).to redirect_to "test_back"
    end

    it "saves exchange rates from internet to db" do
      expect { get :refresh_rates }.to change { Exchange.count }.by(1)
      expect(Exchange.last.currencies).not_to be_empty
    end

    context "for unlogged user" do
      it "redirects to other location" do
        sign_out @user
        get :refresh_rates
        expect(response).not_to redirect_to "test_back"
      end
    end
  end

  describe "GET 'report'" do

    it "redirects when currency is not in base" do
      get :report, money_id: 'foo'
      expect(response).to redirect_to money_index_path
    end
    
    context "for existing currency" do
      before do
        @code = "code"
        exchange = FactoryGirl.create(:exchange)
        FactoryGirl.create(:currency, code: @code, exchange: exchange)
      end

      it "renders a report page for existing currency" do
        get :report, money_id: @code
        expect(response).to render_template(:report)
      end

      it "assigns @exchange with propper keys" do
        get :report, money_id: @code
        expect(assigns(:currency_hash)).to have_key(:name)
        expect(assigns(:currency_hash)).to have_key(:buy_data)
        expect(assigns(:currency_hash)).to have_key(:sell_data)
      end

      it "assigns @chart_prices with propper keys" do
        get :report, money_id: @code
        expect(assigns(:chart_prices)).to have_key(:buy)
        expect(assigns(:chart_prices)).to have_key(:sell)
      end
    end
  end
end
