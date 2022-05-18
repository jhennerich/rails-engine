require 'rails_helper'

RSpec.describe 'The merchants API' do
  it 'sends a list of merchants' do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    response_body = JSON.parse(response.body, symbolize_names: true)
    merchants = response_body[:data]

    expect(response).to be_successful
    expect(merchants.count).to eq(3)

    merchants.each do |merchant|
      expect(merchant).to have_key(:id)
      expect(merchant[:id]).to be_a(String)
      expect(merchant[:type]).to eq('merchant')
      expect(merchant[:attributes]).to have_key(:name)
      expect(merchant[:attributes][:name]).to be_a(String)
    end
  end

  it 'sends data for one merchant given id' do
    merchant = create(:merchant)
    get "/api/v1/merchants/#{merchant.id}"

    merchant = JSON.parse(response.body, symbolize_names: true)
    expect(response).to have_http_status(:ok)
    expect(merchant[:data][:attributes]).to include(:name)
    expect(merchant[:data][:attributes][:name]).to be_a(String)
  end
end
