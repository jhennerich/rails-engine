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

  it "can create a new item" do
    merchant = create(:merchant)
#    item_params = create(:item, merchant_id: merchant.id)
    item_params = {
      name: 'X-wing',
      description: 'Rebel attack fighter',
      unit_price: 2000,
      merchant_id: merchant.id
    }

    headers = {"CONTENT_TYPE" => "application/json"}
    #include this header to make sure params are passed as JSON rather than as plain text

    post "/api/v1/items", headers: headers, params: JSON.generate(item: item_params)
    created_item = Item.last

    expect(response).to be_successful
    expect(created_item.name).to eq(item_params[:name])
    expect(created_item.description).to eq(item_params[:description])
    expect(created_item.unit_price).to eq(item_params[:unit_price])
  end

  it 'can delete an item' do
    merchant = create(:merchant)
    create(:item, merchant_id: merchant.id)
    deleted_item = create(:item, merchant_id: merchant.id)

    items = Item.all
    delete "/api/v1/items/#{deleted_item.id}"

    expect(response).to be_successful
    expect(items.count).to eq(1)
    expect{Item.find(deleted_item.id)}.to raise_error(ActiveRecord::RecordNotFound)

  end
end
