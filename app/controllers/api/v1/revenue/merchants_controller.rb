class Api::V1::Revenue::MerchantsController < ApplicationController
  def index
    return render json: { "message": "your query could not be completed", "error": ['quantity params missing'] }, status: 400 if params[:quantity].blank?
    merchants = Merchant.top_merchants_by_revenue(params[:quantity])
    render json: MerchantNameRevenueSerializer.new(merchants)
  end
end
