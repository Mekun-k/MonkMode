Rails.application.routes.draw do

  mount LetterOpenerWeb::Engine, at: '/letter_opener'

  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  root 'pages#index'
  get 'pages/show'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
