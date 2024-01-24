Rails.application.routes.draw do

  resources :answers, only: %i[index new show create] do
    resources :comments, only: %i[create destroy update], shallow: true
    resource :favorites, only: %i[create destroy]
    collection do
      get 'board'
    end
  end

  resources :notifications, only: %i[index]

  get '/rules', to: 'rules#index'
  post 'rules/update', to: 'rules#update'

  resources :profiles, only: %i[show]

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  resources :users do
    resource :relationships, only: %i[create destroy]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
  end

  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end

  root 'pages#index'
  get 'pages/show'


  resources :pages, only: %i[index  show ] do
    collection do
      get 'answer'
    end
  end
end
