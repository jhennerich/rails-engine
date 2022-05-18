require 'rails_helper'

RSpec.describe 'The items API' do
  it 'sends a list of items' do
    merchant = create(:merchant)
    create_list(:item, 3, merchant_id: merchant.id)

    get '/api/v1/items'

    response_body = JSON.parse(response.body, symbolize_names: true)
    items = response_body[:data]

    expect(response).to be_successful
    expect(items.count).to eq(3)

    items.each do |item|
      expect(item).to have_key(:id)
      expect(item[:id]).to be_a(String)
      expect(item[:type]).to eq('item')
      expect(item[:attributes]).to have_key(:description)
      expect(item[:attributes][:description]).to be_a(String)
      expect(item[:attributes]).to have_key(:unit_price)
      expect(item[:attributes][:unit_price]).to be_a(Float)
      expect(item[:attributes]).to have_key(:merchant_id)
      expect(item[:attributes][:merchant_id]).to be_an(Integer)
    end
  end

  it 'sends data for one item given id' do
    merchant = create(:merchant)
    create_list(:item, 2, merchant_id: merchant.id)
    item1 = Item.first
    item2 = Item.last

    get "/api/v1/items/#{item1.id}"

    item = JSON.parse(response.body, symbolize_names: true)

    expect(response).to have_http_status(:ok)
    expect(response).to be_successful

    expect(item.count).to eq(1)
    expect(item[:data]).to have_key(:id)
    expect(item[:data][:type]).to eq('item')
    expect(item[:data][:attributes]).to include(:name)
    expect(item[:data][:attributes][:name]).to eq(item1.name)
    expect(item[:data][:id]).to_not eq(item2.id)
  end
end
