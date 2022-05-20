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

#    delete "/api/v1/items/foo"
  end

  it "can update an existing item" do

    id = create(:item).id
    previous_name = Item.last.name
    item_params = { name: "X-wing" }
    headers = {"CONTENT_TYPE" => "application/json"}

    patch "/api/v1/items/#{id}", headers: headers, params: JSON.generate({item: item_params})
    item = Item.find_by(id: id)

    expect(response).to be_successful
    expect(item.name).to_not eq(previous_name)
    expect(item.name).to eq("X-wing")
  end

  it "can get the merchant data for a given item ID" do
    merchant1 = create(:merchant)
    merchant2 = create(:merchant)
    item1 = create(:item, merchant_id: merchant1.id)
    item2 = create(:item, merchant_id: merchant2.id)

    get "/api/v1/items/#{item1.id}/merchant"
    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(merchant.count).to eq(1)


    expect(merchant[:data][:id]).to eq(merchant1.id.to_s)
    expect(merchant[:data][:id]).to_not eq(merchant2.id)

    expect(merchant[:data][:attributes]).to have_key(:name)
    expect(merchant[:data][:attributes][:name]).to eq(merchant1.name)

    expect(merchant.count).to_not eq(0)
  end

  it 'sends data for the first item from find result Happy Path' do

    merchant = create(:merchant, name: "Star Wars")
    item = create(:item, name: "A-wing", merchant_id: merchant.id)
    create(:item, merchant_id: merchant.id)
    create(:item, merchant_id: merchant.id)
    create(:item, merchant_id: merchant.id)

    allow(Item).to receive(:search_return_one).and_return(item)
    search = "wing"

    get "/api/v1/items/find?name=#{search}"

    results = JSON.parse(response.body, symbolize_names: true)

    expect(Item).to have_received(:search_return_one).with(search).once
    expect(response).to be_successful
    expect(results.count).to eq(1)
    expect(results[:data].count).to eq(3)
    expect(results[:data][:attributes]).to have_key(:name)
    expect(results[:data][:attributes][:name]).to eq(item.name)

  end

  it 'responds with error for empty search (Sad Path)' do


    get "/api/v1/items/find?name="
    results = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(400)
    expect(results.count).to eq(2)
    expect(results).to have_key(:message)
    expect(results[:message]).to eq("your query could not be completed")
  end

  it 'responds with error if no search data is provided' do

    get "/api/v1/items/find"

    results = JSON.parse(response.body, symbolize_names: true)
    expect(response.status).to eq(400)
    expect(results.count).to eq(2)
    expect(results).to have_key(:message)
    expect(results[:message]).to eq("your query could not be completed")
  end

  it 'sends data for all items from find result' do
    merchant = create(:merchant, name: "Star Wars")
    item = create(:item, name: "A-wing", merchant_id: merchant.id)
    create(:item, merchant_id: merchant.id)
    create(:item, merchant_id: merchant.id)
    create(:item, merchant_id: merchant.id)

    allow(Item).to receive(:search)
    search = "wing"

    get "/api/v1/items/find_all?name=#{search}"

    results = JSON.parse(response.body, symbolize_names: true)
  end



  it 'finds all items by min_price search' do
    merchant = create(:merchant, name: "Star Wars")
    item = create(:item, name: "A-wing", unit_price: 300, merchant_id: merchant.id)
    item2 = create(:item, name: "B-wing", unit_price: 200, merchant_id: merchant.id)
    item3 = create(:item, name: "X-wing", unit_price: 100, merchant_id: merchant.id)

    get "/api/v1/items/find?min_price=150"

    results = JSON.parse(response.body, symbolize_names: true)[:data]

    expect(response).to be_successful
    expect(results[:attributes][:name]).to eq('B-wing')

  end
  it "Can't search for price and name together" do

    get "/api/v1/items/find?min_price=0&man_price=100&name='foo'"
    results = JSON.parse(response.body, symbolize_names: true)

    expect(response.status).to eq(400)
    expect(results.count).to eq(2)
    expect(results).to have_key(:message)
    expect(results[:message]).to eq("your query could not be completed")
  end
end
