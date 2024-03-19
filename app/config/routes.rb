Rails.application.routes.draw do
  get "session" => "session#new"
  post "session" => "session#create"
  delete "session" => "session#destroy"

  resources :users, only: [:new, :create, :show]

  get 'welcome/index'

  resources :shared_files, only: [:new, :create, :show, :update]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  root "welcome#index"
end
