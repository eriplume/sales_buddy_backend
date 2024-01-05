Rails.application.routes.draw do
  resources :users, only: [] do
    collection do
      post 'authenticate', to: 'users#authenticate'
    end
    member do
      get 'notifications', to: 'users#show'
      patch 'update_notifications', to: 'users#update_notifications'
    end
  end
  resources :dairy_records, only: %i[index create]
  resources :customer_records, only: [:index]
  resources :customer_types, only: [:index]
  resources :weekly_reports, only: %i[index create]
  resources :monthly_reports, only: %i[index create]
  resources :weekly_targets, only: %i[index create]
  resources :job_records, only: %i[index create]
end
