class Api::V1::ItemsController < ApplicationController

  def index
    render json: ItemSerializer.new(Item.all), status: :ok
  end

  def show
    item = Item.find(params[:id])
    render json: ItemSerializer.new(item), status: :ok
  end

  def create
    render json: ItemSerializer.new(Item.create(item_params)), status: :created
  end

  def destroy
    render json: Item.destroy(params[:id]), status: :no_content
  end

  def update
    if Merchant.exists?(params[:item][:merchant_id])
      render json: ItemSerializer.new(Item.update(params[:id], item_params)), status: :ok
    else 
      render json: {error: {message: "The merchant id number you have submitted. #{:merchant_id}, does not exist"}}, status: "Not Found", code: 404
    end
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end