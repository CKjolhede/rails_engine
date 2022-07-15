Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'api/v1/merchants/find', to: 'api/v1/merchants#find'
  get 'api/v1/merchants/find_all', to: 'api/v1/merchants#find_all'
  get 'api/v1/items/find', to: 'api/v1/items#find'
  get 'api/v1/items/find_all', to: 'api/v1/items#find_all'
  get 'api/v1/items/:id/merchant', to: 'api/v1/merchant_items#show'
 
  namespace :api do 
    namespace :v1 do 
      resources :items, only: [:index, :show, :create, :update, :destroy] 
      resources :merchants, only: [:index, :show] do 
        resources :items, only: [:index], controller: :merchant_items
      end
    end
  end
end


#   get 'api/v1/merchants/find', to: 'api/v1/merchants#find'
#   namespace :api do
#     namespace :v1 do
#       # get '/merchants/find', to: 'merchants#find'
#       # get '/items/find_all', to: 'items#find_all'
#       # get '/items/find', to: 'items#find'
#       resources :merchants, only: [:index, :show] do
#         resources :items, only: [:index], controller: "merchant_items" 
#       end

#       get '/items/:id/merchant', to: 'merchant_items#show'
#       resources :items do
#         # resources :merchants, only: [:show], controller: "merchant_items", action: :show
#       end
#     end
#   end
# end
