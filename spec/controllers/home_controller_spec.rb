require 'rails_helper'

RSpec.describe HomeController, type: :controller do
    describe "#index" do
        # 正常にレスポンスを返すこと
        it "responds successfully" do
            get :index
            expect(response).to be_success
        end
    end
end