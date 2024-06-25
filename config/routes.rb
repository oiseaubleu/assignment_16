Rails.application.routes.draw do
  root 'tasks#index'
  resources :tasks
  resources :users, only: %i[new create show edit update destroy]
  namespace :admin do
    resources :users
  end
  resources :sessions, only: %i[new create destroy]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
