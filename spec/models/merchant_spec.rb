require 'rails_helper'

RSpec.describe Merchant do
  it "can return all Merchants from search result" do
    merchant = create(:merchant, name: "Star Wars R Us")
    merchant2 = create(:merchant, name: "sTar Trek R Us")
    merchant3 = create(:merchant, name: "Outlander R Us")
    create_list(:merchant, 3)

    results = Merchant.search("Star")

    expect(results.include?(merchant)).to be true
    expect(results.include?(merchant2)).to be true
    expect(results.include?(merchant3)).to be false
  end

  it 'can return one merchant from search result' do
    merchant = create(:merchant, name: "Star Wars R Us")
    merchant2 = create(:merchant, name: "sTar Trek R Us")
    merchant3 = create(:merchant, name: "Outlander R Us")

    results = Merchant.search_return_one("Star")
    expect(results).to eq(merchant)
  end
end
