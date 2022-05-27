Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get '/merchants/find', to: 'merchants#find'
      get '/merchants/find_all', to: 'merchants#find_all'
      get '/items/find', to: 'items#find'
      get '/items/find_all', to: 'items#find_all'
      get '/merchants/most_items', to: 'most_items#index'

      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index], controller: :merchant_items
      end
      resources :items do
        resources :merchant, only: [:index], controller: :item_merchant
      end

      namespace :revenue do
        resources :merchants, only: [:index]
      end
    end
  end
end
