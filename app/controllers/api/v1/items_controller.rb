class Api::V1::ItemsController < ApplicationController
  before_action :check_params, only: [:find, :find_all]

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
    if item
      item.destroy!
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
    return if check_params

    item_search = Item.search_return_min_price(params[:min_price]) if params.has_key?(:min_price)
    item_search = Item.search_return_max_price(params[:max_price]) if params.has_key?(:max_price)

    if params.has_key?(:min_price) && params.has_key?(:max_price)
      item_search = Item.search_return_min_max_price(params[:min_price],params[:max_price])
    end

    item_search = Item.search_return_one(params[:name]) if params.has_key?(:name)

    find_response(item_search)
  end

  def find_all
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
        "error": []
      }
    end

    def find_response(item)
      if item
        render json: ItemSerializer.new(item), status: :ok
      else
        render json: { data: { error: 'Item(s) not found' } }, status: 200
      end
    end

    def check_params
      return render json: { "message": "your query could not be completed", "error": ["Can't search name and price together"] }, status: 400 if name_and_price_in_params
      return render json: { "message": "your query could not be completed", "error": ['search params missing'] }, status: 400 if params[:name].blank? && !price_in_params
      return render json: { "message": "your query could not be completed", "error": ['min price must be greater than 0'] }, status: 400 if ( params[:min_price].to_f < 0 )
      return render json: { "message": "your query could not be completed", "error": ['max price must be greater than 0'] }, status: 400 if ( params[:max_price].to_f < 0 )

      if params.has_key?(:min_price) && params[:min_price].blank?
        return render json: { "message": "your query could not be completed", "error": ['min price search params missing'] }, status: 400
      end

      if params.has_key?(:max_price) && params[:max_price].blank?
        return render json: { "message": "max price search params missing" }, status: 400
      end

      if params.has_key?(:max_price) && (params[:min_price].to_f > params[:max_price].to_f)
        return render json: { 'message': 'max price must be greater than min price' }, status: 400
      end
    end

    def name_and_price_in_params
      params.has_key?(:min_price) && params.has_key?(:name) ||
      params.has_key?(:max_price) && params.has_key?(:name) ||
      params.has_key?(:min_price) && params.has_key?(:max_price) && params.has_key?(:name)
    end

    def price_in_params
      params.has_key?(:min_price) || params.has_key?(:max_price)
    end
end
