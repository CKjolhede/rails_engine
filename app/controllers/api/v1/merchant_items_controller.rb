class Api::V1::MerchantItemsController < ApplicationController

  def index
    merchant = Merchant.find(params[:merchant_id])
    render json: ItemSerializer.new(merchant.items.all)
  end

  def show
    item = Item.find(params[:id])
    merchant = Merchant.find(item.merchant_id)
    render json: MerchantSerializer.new(merchant), status: :ok
  end
end