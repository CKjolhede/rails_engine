class Api::V1::MerchantItemsController < ApplicationController

  def index
    # binding.pry
    merchant = Merchant.find(params[:merchant_id])
    render json: ItemSerializer.new(merchant.items.all)
  end

  def show
    merchant = Merchant.find(params[:id])
    render json: MerchantSerializer.new(merchant), status: :ok
  end
end