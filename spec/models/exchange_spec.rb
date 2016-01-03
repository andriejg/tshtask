require 'spec_helper'

describe Exchange do
	describe "#get_nbp_xml" do

    before { @exchange = FactoryGirl.build(:exchange) }

		it 'downloads file from the internet' do
      @exchange.get_nbp_xml
      expect(@exchange.file).to be_a File
      expect(@exchange.file).to be_closed
		end
	end
end
