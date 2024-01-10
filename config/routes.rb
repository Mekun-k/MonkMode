Rails.application.routes.draw do


  get 'answers/index'
  get 'answers/new'
  get 'answers/show'
  post 'answers/create', to: 'answers#create'

  resources :child_answers

  get '/rules', to: 'rules#index'
  post 'rules/update', to: 'rules#update'



  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end

  root 'pages#index'
  get 'pages/show'
end
