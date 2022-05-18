FactoryBot.define do
  factory :bulk_discount do
    name { "MyString" }
    percentage { 1 }
    quantity_threshold { 1 }
    merchant { nil }
  end
end
