Rails.application.routes.draw do
  resources :users do
    collection do
      post 'authenticate', to: 'users#authenticate'
      get 'current', to: 'users#show_current_user'
      get 'admin_status'
      patch 'update_notifications', to: 'users#update_notifications'
      patch 'update_task_notifications', to: 'users#update_task_notifications'
    end
  end

  resources :dairy_records, only: %i[index create]
  resources :customer_records, only: [:index]
  resources :customer_types, only: [:index]
  resources :weekly_reports, only: %i[index create]
  resources :monthly_reports, only: %i[index create update]
  resources :weekly_targets, only: %i[index create]
  resources :job_records, only: %i[index create]
  resources :tasks, only: %i[index create update destroy] do
    member do
      patch 'complete', to: 'tasks#complete'
    end
    resources :comments, only: %i[create update destroy]
  end
  resources :groups, only: %i[index create]
  post 'groups/join', to: 'group_memberships#join'

  namespace :admin do
    resources :users, only: %i[index update destroy]
    resources :customer_types, only: %i[index create update destroy]
    resources :dairy_records, only: %i[index destroy]
    resources :weekly_reports, only: %i[index destroy]
  end
end
