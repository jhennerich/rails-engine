class Api::V1::ItemsController < ApplicationController
  before_action :check_params_for_name, only: [:find, :find_all]

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
#  rescue ActiveRecord::RecordNotFound
#      wip = render json: error_message, status: 404
    if item
      item.destroy!
#      render status: 204
    end
  end

  def update
    item = Item.find(params[:id])
    if item.update(item_params)
      render json: ItemSerializer.new(item), status: :created
    else
      render json: error_message, status: 404
    end
  end

  def find
    if check_params_for_name
      render json: error_message, status: 400
      return
    end
    item_search = Item.search_return_one(params[:name])
    find_response(item_search)
  end

  def find_all
    if check_params_for_name
      render json: error_message, status: 400
      return
    end
    item_search = Item.search(params[:name])
    find_response(item_search)
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

    def find_response(item)
      if item
        render json: ItemSerializer.new(item), status: :ok
      else
        render json: { data: { error: 'Item(s) not found' } }, status: 200
      end
    end

    def check_params_for_name
      check =  !params[:name] || params[:name] == ''
    end
end
