Rails.application.routes.draw do
  devise_for :users
  #resources :コントローラ, option(only/except), [:action]
  resources :users, only: [:show, :edit, :update]
  root to: 'top#index'
  resources :groups, only: [:show, :edit, :update]
  resources :questions, only: [:create, :show]
  resources :answers, only: [:new, :create, :edit, :update]

end
