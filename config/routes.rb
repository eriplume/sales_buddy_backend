Rails.application.routes.draw do
  resources :users, only: [] do
    collection do
      post 'authenticate', to: 'users#authenticate'
    end
  end
  resources :dairy_records, only: %i[index create]
  resources :customer_records, only: [:index]
  resources :customer_types, only: [:index]
  resources :weekly_reports, only: %i[index create]
end
