Rails.application.routes.draw do
  root to: 'home#index'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  get 'search', to: 'home#search'
  get 'explanation', to: 'home#explanation', as: 'explanation'
  resources :hotels, only: [:index, :show] do
    collection do
      get 'search'
      get 'bookmarks'
    end
    resources :comments, only: %i[create edit update destroy], shallow: true
  end

  resources :bookmarks, only: %i[create destroy]
  resources :users, only: %i[new create]
  resources :tags, only: [:new, :create, :destroy]

  # SorceryのTwitter認証用ルート
  get '/auth/:provider/callback', to: 'oauth_callbacks#twitter'
  get '/auth/failure', to: 'sessions#failure'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  
  # Maps controller route
  get '/maps', to: 'maps#index'
  
  # Defines the root path route ("/")
  # root "posts#index"
  end
