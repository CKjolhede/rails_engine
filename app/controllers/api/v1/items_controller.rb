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

  def find_all
     items = Item.search(params[:name])
  
    if items.nil?
      render json: {data: {error: "No items found with search term: #{params[:name]}"}}, status: 200
    else
      render json: ItemSerializer.new(items), status: 200
    end
  end
  
  def find 
    # if params[:name].present?
    #     render json: {error: {message: "cannot send name and min_price"}}, status: 400
    if params[:min_price].present? && params[:max_price].present?
        items = Item.minmax_price_search(params[:min_price], params[:max_price])
        item = items.first
    elsif params[:min_price].present?
        item = Item.search_min_price(params[:min_price])
        item = items.first
        binding.pry
    else params[:max_price].present?
        items = Item.search_max_price(params[:max_price])
        item = items.first
    end
    render json: ItemSerializer.new(item), status: 200 
  end
  
  private
  
  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id, :min_price, :max_price)
  end
end
# if params[:name].present?
# elsif params[:min_price].to_i < 0 
#   render json: {data: {error: "min price price must be greater than zero"}}, status: 400
# elsif items = Item.min_price_search(params[:min_price]).nil?
#   render json: {data: :undefined}, status: "null", code: 200
# else 
# end  
# elsif params[:max_price].present?
#   # binding.pry
#   # if params[:name].present?
#   #   render json: {data: {error: "cannot send name and max_price"}}, status: "null", code: 400
#   # elsif params[:max_price].to_i < 0 
#   #   render json: {data: {error: "max price price must be greater than zero"}}, status: "null", code: 400
#   # elsif items = Item.max_price_search(params[:max_price]).nil?
#   #   render json: ItemSerializer.new(items), status: 200
#   # else 
#     items = Item.max_price_search(params[:max_price])
#     render json: ItemSerializer.new(items), status: 200 
# #   end
# else
#   render json: {data: {error: "Cannot leave search field blank"}}, status: 400
# end