Rails.application.routes.draw do

  resources :answers, only: %i[index new show create] do
    resource :favorites, only: [:create, :destroy]
    collection do
      get 'board'
    end
  end

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


  resources :pages, only: %i[index  show ] do
    collection do
      get 'answer'
    end
  end
end
