class Api::V1::MerchantsController < ApplicationController

  def index
    render json: MerchantSerializer.new(Merchant.all), status: :ok
  end

  def show
    render json: MerchantSerializer.new(Merchant.find(params[:id])), status: :ok
  end

  def find
    search_word = Merchant.search(params[:name])
    if search_word.nil?
      render json: {data: {error: "No merchant found with #{params[:name]} in the name"}}, status: 200
    else
      render json: MerchantSerializer.new(search_word), status: 200
    end
  end

  def most_items
    merchants = Merchant.most_items(params[:quantity])
    render json: ItemsSoldSerializer.new(merchants)
  end
end