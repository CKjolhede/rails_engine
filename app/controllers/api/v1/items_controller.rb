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

  # def find 
  #   item = Item.search_price(params)
  #   # [:name] = nil, params[:min_price] = nil, params[:max_price] = nil)
  #   if item.nil? 
  #     ErrorSerializer.is_nil(200)
  #     render json: ItemsSerializer.new(message), status: status
  #   else
  #     id = 1
  #     render json: ItemSerializer.new(item), status: 200
  #   end
  # end
  
  # def find 
  #   # if params[:name].present?
  #   #     render json: {error: {message: "cannot send name and min_price"}}, status: 400
  #   if params[:min_price].present? && params[:max_price].present?
  #       items = Item.minmax_price_search(params[:min_price], params[:max_price])
  #       item = items.first
  #   elsif params[:min_price].present?
  #       items = Item.search_min_price(params[:min_price])
  #       item = items.first
  #       binding.pry
  #   else params[:max_price].present?
  #       items = Item.search_max_price(params[:max_price])
  #       item = items.first
  #   end
  #   render json: ItemSerializer.new(item), status: 200 
  # end
  
  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end