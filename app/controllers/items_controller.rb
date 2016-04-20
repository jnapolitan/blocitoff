class ItemsController < ApplicationController

  before_action :authenticate_user!

  def new
    @user = User.find(params[:user_id])
    @item = Item.new
  end

  def create
    @user = User.find(params[:user_id])
    @item = @user.items.build(item_params)
    @item.user = current_user

    if @item.save
      flash[:notice] = "Todo created, now get to work!"
      redirect_to @user
    else
      flash.now[:alert] = "There was an error creating your todo. Please try again."
      render :new
    end
  end

  private

  def item_params
    params.require(:item).permit(:name)
  end
end
