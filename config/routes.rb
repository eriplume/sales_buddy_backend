Rails.application.routes.draw do
  resources :users, only: [] do
    collection do
      post 'authenticate', to: 'users#authenticate'
    end
  end
  resources :dairy_records, only: [:index, :create]
  resources :customer_records, only: [:index]
end
