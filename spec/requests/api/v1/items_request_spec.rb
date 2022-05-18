require 'rails_helper'

RSpec.describe 'The items API' do
  it 'sends a list of items' do
    merchant = create(:merchant)
    create_list(:item, 3, merchant_id: merchant.id)

    get '/api/v1/items'

    response_body = JSON.parse(response.body, symbolize_names: true)
    items = response_body[:data]
    binding.pry

    expect(response).to be_successful
    expect(items.count).to eq(3)

    items.each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(String)
      expect(item[:type]).to eq('item')
      expect(item[:attributes]).to have_key(:name)
      expect(item[:attributes][:name]).to be_a(String)
    end
  end

  xit 'sends data for one merchant given id' do
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

  xit 'sends data for all items of a given merchant' do
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
end
