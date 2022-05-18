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
end
