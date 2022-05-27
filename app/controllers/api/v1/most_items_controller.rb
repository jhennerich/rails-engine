class Api::V1::MostItemsController < ApplicationController
  def index
    if params[:quantity].to_i != 0  && params[:quantity] > 0
      merchants = Merchant.top_merchants_by_items_sold(params[:quantity])
      render json: MerchantSerializer.new(merchants)
    elsif params[:quantity].blank?
      params[:quantity] = 5
      merchants = Merchant.top_merchants_by_items_sold(params[:quantity])
      render json: MerchantSerializer.new(merchants)
    else
      return render json: { "message": "your query could not be completed", "error": ['quantity params is incorrect'] }, status: 400
    end
  end
end
