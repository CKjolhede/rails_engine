class Api::V1::SearchesController < ApplicationController
    
  def find 
    item = Item.search_price(params)
    # [:name] = nil, params[:min_price] = nil, params[:max_price] = nil)
    if item.nil? 
      ErrorSerializer.is_nil(200)
    else
      render json: ItemSerializer(item), status: 200
    end
  end
end