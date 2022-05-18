class Item < ApplicationRecord
  belongs_to :merchant

  def self.search_return_one(search_params)
    where("name ILIKE ?", "%#{search_params}%").order(:name).first
  end

  def self.search(search_params)
    where("name ILIKE ?", "%#{search_params}%")
  end
end
