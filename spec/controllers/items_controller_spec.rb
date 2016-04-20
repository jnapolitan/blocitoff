require 'rails_helper'
require 'random_data'
require 'devise'

RSpec.describe ItemsController, type: :controller do
  let(:item) { create(:item, user: user) }
  let(:user) { create(:user) }


  context "user not signed in" do
    describe "GET new" do
      it "returns http redirect" do
        get :new, user_id: user.id
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "POST create" do
      it "returns http redirect" do
        post :create, user_id: user.id, item: {name: RandomData.random_sentence}
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  context "signed in user" do
    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      user = FactoryGirl.create(:user)
      user.confirm!
      sign_in user
    end

    describe "GET new" do
      it "returns http success" do
        get :new, user_id: user.id
        expect(response).to have_http_status(:success)
      end

      it "renders the #new view" do
        get :new, user_id: user.id
        expect(response).to render_template :new
      end

      it "instantiates @item" do
        get :new, user_id: user.id
        expect(assigns(:item)).not_to be_nil
      end
    end

    describe "POST create" do
      it "redirects to the users show view" do
        post :create, user_id: user.id, item: {name: RandomData.random_sentence, user_id: user.id}
        expect(response).to redirect_to(user)
        puts user
      end
    end
  end
end
