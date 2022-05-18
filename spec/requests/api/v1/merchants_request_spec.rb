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
    create_list(:merchant, 2)
    merchant1 = Merchant.first
    merchant2 = Merchant.last

    get "/api/v1/merchants/#{merchant1.id}"

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to have_http_status(:ok)
    expect(response).to be_successful

    expect(merchant.count).to eq(1)
    expect(merchant[:data]).to have_key(:id)
    expect(merchant[:data][:type]).to eq('merchant')
    expect(merchant[:data][:attributes]).to include(:name)
    expect(merchant[:data][:attributes][:name]).to eq(merchant1.name)
    expect(merchant[:data][:id]).to_not eq(merchant2.id)
  end

  it 'sends data for all items of a given merchant' do
    merchant1 = create(:merchant)
    merchant2 = create(:merchant)

    create_list(:item, 2, merchant_id: merchant1.id)
		create_list(:item, 2, merchant_id: merchant2.id)

    get "/api/v1/merchants/#{merchant1.id}/items"

		merchant1_items = JSON.parse(response.body, symbolize_names: true)

		expect(response).to be_successful
		expect(merchant1_items.count).to eq(1)
		expect(merchant1_items[:data].first).to have_key(:id)
		expect(merchant1_items[:data].first[:attributes]).to have_key(:name)
		expect(merchant1_items[:data].first[:attributes]).to have_key(:description)
		expect(merchant1_items[:data].first[:attributes]).to have_key(:unit_price)
		expect(merchant1_items[:data].first[:merchant_id]).to_not eq(merchant2.id)
  end

  it 'sends data for all merchants from find result' do
    merchant1 = create(:merchant, name: "Star Wars")
    merchant2 = create(:merchant, name: "Star Trek")

    allow(Merchant).to receive(:search).and_return([merchant1, merchant2])
    search = "Star"

    get "/api/v1/merchants/find?name=#{search}"

    results = JSON.parse(response.body, symbolize_names: true)

   expect(Merchant).to have_received(:search).with(search).once
   expect(response).to be_successful
   expect(results.count).to eq(1)
   expect(results[:data].count).to eq(2)
   expect(results[:data].first).to have_key(:id)
   expect(results[:data].first[:attributes]).to have_key(:name)

  end
end
