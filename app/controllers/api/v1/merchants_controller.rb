class Api::V1::MerchantsController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.all), status: :ok
  end

  def show
    render json: MerchantSerializer.new(Merchant.find(params[:id])), status: :ok
  end

  def find
    merchant = Merchant.search_return_one(params[:name])
    find_response(merchant)
  end

  def find_all
    merchant = Merchant.search(params[:name])
    find_response(merchant)
  end

  private
    def find_response(merchant)
      if merchant
        render json: MerchantSerializer.new(merchant), status: :ok
      else
        render json: { data: { error: 'Merchant not found' } }
      end
    end
end
