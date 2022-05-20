require 'rails_helper'

RSpec.describe Item do
  it "can return one item from search result" do

    merchant = create(:merchant, name: "Star Wars R Us")
    item1 = create(:item, name:"A-wing", merchant_id: merchant.id)
    item2 = create(:item, name:"X-wing", merchant_id: merchant.id)
    item3 = create(:item, name:"Y-wing", merchant_id: merchant.id)

    results = Item.search_return_one("wing")
    expect(results).to eq(item1)
  end

  it "can return all items from search result" do
    merchant = create(:merchant, name: "Star Wars R Us")
    item1 = create(:item, name:"A-wing", merchant_id: merchant.id)
    item2 = create(:item, name:"X-wing", merchant_id: merchant.id)
    item3 = create(:item, name:"Y-wing", merchant_id: merchant.id)

    results = Item.search("wing")
    expect(results).to eq([item1, item2, item3])
  end

  it '#search_return_min_price' do
    merchant = create(:merchant, name: "Star Wars R Us")
    item1 = create(:item, name:"A-wing", unit_price: 100, merchant_id: merchant.id)
    item2 = create(:item, name:"X-wing", unit_price: 200, merchant_id: merchant.id)
    results = Item.search_return_min_price(100)
    expect(results).to eq(item1)
  end

  it '#search_return_min_price_all' do
    merchant = create(:merchant, name: "Star Wars R Us")
    item1 = create(:item, name:"A-wing", unit_price: 100, merchant_id: merchant.id)
    item2 = create(:item, name:"B-wing", unit_price: 200, merchant_id: merchant.id)
    item3 = create(:item, name:"X-wing", unit_price: 300, merchant_id: merchant.id)
    results = Item.search_return_min_price_all(200)

    expect(results).to eq([item2,item3])
  end

  it '#search_return_max_price' do
    merchant = create(:merchant, name: "Star Wars R Us")
    item1 = create(:item, name:"A-wing", unit_price: 100, merchant_id: merchant.id)
    item2 = create(:item, name:"X-wing", unit_price: 200, merchant_id: merchant.id)
    results = Item.search_return_max_price(250)

    expect(results).to eq(item2)
  end

  it '#search_return_max_price_all' do
    merchant = create(:merchant, name: "Star Wars R Us")
    item1 = create(:item, name:"A-wing", unit_price: 100, merchant_id: merchant.id)
    item2 = create(:item, name:"B-wing", unit_price: 200, merchant_id: merchant.id)
    item3 = create(:item, name:"X-wing", unit_price: 300, merchant_id: merchant.id)
    results = Item.search_return_max_price_all(250)

    expect(results).to eq([item2, item1])
  end

  it '#search_return_min_max_price' do
    merchant = create(:merchant, name: "Star Wars R Us")
    item1 = create(:item, name:"A-wing", unit_price: 100, merchant_id: merchant.id)
    item2 = create(:item, name:"X-wing", unit_price: 200, merchant_id: merchant.id)
    results = Item.search_return_min_max_price(100,250)

    expect(results).to eq(item1)
  end

  it '#search_return_min_max_price_all' do
    merchant = create(:merchant, name: "Star Wars R Us")
    item1 = create(:item, name:"A-wing", unit_price: 100, merchant_id: merchant.id)
    item2 = create(:item, name:"A-wing", unit_price: 100, merchant_id: merchant.id)
    item3 = create(:item, name:"X-wing", unit_price: 200, merchant_id: merchant.id)
    results = Item.search_return_min_max_price_all(50,250)

    expect(results).to eq([item1, item2, item3])
  end
end
