class Item < ApplicationRecord
  belongs_to :merchant

  def self.search_return_one(search_params)
    where("name ILIKE ?", "%#{search_params}%").order(:name).first
  end

  def self.search_return_min_price(min_price)
    where("unit_price >= #{min_price.to_f} ").order(:unit_price).first
  end

  def self.search_return_min_price_all(min_price)
    where("unit_price >= #{min_price.to_f} ").order(:unit_price)
  end

  def self.search_return_max_price(max_price)
    where("unit_price <= #{max_price.to_f} ").order(unit_price: :desc).first
  end

  def self.search_return_max_price_all(max_price)
    where("unit_price <= #{max_price.to_f} ").order(unit_price: :desc)
  end

  def self.search_return_min_max_price(min_price, max_price)
    where( unit_price: min_price.to_f..max_price.to_f).order(:unit_price).first
  end

  def self.search_return_min_max_price_all(min_price, max_price)
    where( unit_price: min_price.to_f..max_price.to_f).order(:unit_price)
  end

  def self.search(search_params)
    where("name ILIKE ?", "%#{search_params}%")
  end
end
