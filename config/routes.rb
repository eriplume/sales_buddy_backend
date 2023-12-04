Rails.application.routes.draw do
  resources :users, only: [] do
    collection do
      post 'authenticate', to: 'users#authenticate'
    end
  end
end
