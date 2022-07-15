class Api::V1::MerchantsController < ApplicationController

  def index
    render json: MerchantSerializer.new(Merchant.all), status: :ok
  end

  def show
    error_response if invalid_id
    render json: MerchantSerializer.new(Merchant.find(params[:id])), status: :ok if !invalid_id?
  end

  def find
    search_word = Merchant.search(params[:name])
    if search_word.nil?
      render json: {data: {error: "No merchant found with #{params[:name]} in the name"}}, status: 200
    else
      render json: MerchantSerializer.new(search_word), status: 200
      # binding.pry
    end
  end
end