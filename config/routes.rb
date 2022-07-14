Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index], controller: "merchant_items" 
      end

      get '/items/:id/merchant', to: 'merchant_items#show'

      resources :items do
        # resources :merchants, only: [:show], controller: "merchant_items", action: :show
      end
    end
  end
end
