class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new(Item.all), status: :ok
  end

  def show
    render json: ItemSerializer.new(Item.find(params[:id])), status: :ok
  end

  def create
    item = Item.create(item_params)
    if item.save
      render json: ItemSerializer.new(item), status: :created
    end
  end

  def destroy
    item = Item.find(params[:id])
    Item.destroy(params[:id])
    render json: ItemSerializer.new(item)
  end

  def update
    item = Item.find(params[:id])
    if item.update(item_params)
      render json: ItemSerializer.new(item), status: :created
    else
      render json: error_message, status: 404
    end
  end


  private
    def item_params
      params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
    end

    def error_message
      {
        "message": "your query could not be completed",
        "errors": []
      }
    end
end
