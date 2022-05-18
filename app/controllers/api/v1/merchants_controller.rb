class Api::V1::MerchantsController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.all), status: :ok
  end

  def show
    render json: MerchantSerializer.new(Merchant.find(params[:id])), status: :ok
  end
end
