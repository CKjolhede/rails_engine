class Api::V1::ItemsController < ApplicationController

  def index
    render json: ItemSerializer.new(Item.all), status: :ok
  end
end