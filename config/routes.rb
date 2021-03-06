Rails.application.routes.draw do

  root to: 'users#show'

  devise_for :users, prefix: "my", :controllers => { registrations: 'registrations' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :users

  resources :subscriptions

  resources :plans

  post "/plan_billed", to: "plans#plan_billed"

end
