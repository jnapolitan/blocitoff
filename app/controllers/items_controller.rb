class ItemsController < ApplicationController

  before_action :require_sign_in
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :authorize_user, only: [:destroy]

  def new
    @user = User.find(params[:user_id])
    @item = Item.new
  end

  def create
    @user = User.find(params[:user_id])
    @item = @user.items.new(item_params)
    @item.user = current_user

    if @item.save
      flash[:notice] = "Todo created, now get to work!"
      redirect_to @user
    else
      flash.now[:alert] = "There was an error creating your todo. Please try again."
      render :new
    end
  end

  def destroy
    @user = User.find(params[:user_id])
    @item = Item.find(params[:id])

    if @item.destroy
      flash[:notice] = "Item was completed!"
    else
      flash[:alert] = "Item couldn't be marked completed. Try again."
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  private

  def item_params
    params.require(:item).permit(:name)
  end

  def authorize_user
    item = Item.find(params[:id])
    unless current_user == item.user
      flash[:alert] = "You do not have permission to do that."
    end
  end
end
