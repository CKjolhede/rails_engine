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

private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end