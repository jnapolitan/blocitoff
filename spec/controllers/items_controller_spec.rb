require 'rails_helper'
require 'random_data'
require 'devise'

RSpec.describe ItemsController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:item) { create(:item, user: user) }


  context "guest" do
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

    describe "DELETE destroy" do
      it "redirects to new user session" do
        delete :destroy, format: :js, user_id: user.id, id: item.id
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  context "signed in user doing CRUD on items they own" do
    before do
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
      end

      it "increases the number of Item by 1" do
        expect{ post :create, user_id: user.id, item: {name: RandomData.random_sentence} }.to change(Item,:count).by(1)
      end

      it "assigns the new item to @item" do
        post :create, user_id: user.id, item: {name: RandomData.random_sentence, user_id: user.id}
        expect(assigns(:item)).to eq Item.last
      end
    end

    describe "DELETE destroy" do
      it "deletes the item" do
        delete :destroy, format: :js, user_id: user.id, id: item.id
        count = Item.where({id: item.id}).count
        expect(count).to eq 0
      end

      it "returns http success" do
        delete :destroy, format: :js, user_id: user.id, id: item.id
        expect(response).to have_http_status(:success)
      end
    end
  end

  context "signed in user doing CRUD on items they don't own" do
    before do
      sign_in user
    end

    describe "DELETE destroy" do
      it "is unauthorized" do
        delete :destroy, format: :js, user_id: other_user.id, id: item.id
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
