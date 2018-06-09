Rails.application.routes.draw do

  namespace :admin do
    resources :users
    resources :conversations
    resources :reviews
    resources :listings
    resources :messages
    resources :notifications
    resources :photos
    resources :reservations
    resources :guest_reviews
    resources :host_reviews

    root to: "users#index"
  end

  root 'pages#home'

  devise_for :users,
             path: '',
             path_names: {sign_in: 'login', sign_out: 'logout', edit: 'profile', sign_up: 'registration'},
             controllers: {omniauth_callbacks: 'omniauth_callbacks', registrations: 'registrations', confirmations: 'confirmations' }


  resources :users, only: [:show] do
    member do

      post '/verify_phone_number' => 'users#verify_phone_number'
      patch '/update_phone_number' => 'users#update_phone_number'

      patch '/update_license' => 'users#update_license'

      patch '/update_bank_account' => 'users#update_bank_account'

    end
  end

  get '/certification' => "users#certification"

  get '/payment_method' => "users#payment"
  get '/payout_method' => "users#payout"
  post '/add_card' => "users#add_card"


  resources :listings, except: [:edit] do
    member do


      get 'information'
      get 'exhibition'
      get 'photo_upload'
      get 'preload'
      get 'preview'
    end
    resources :photos, only: [:create, :destroy]
    resources :reservations, only: [:create]
  end

  resources :guest_reviews, only: [:create, :destroy]
  resources :host_reviews, only: [:create, :destroy]

  get '/my_reservations' => 'reservations#my_reservations'
  get '/guest_reservations' => 'reservations#guest_reservations'

  get 'search' => 'pages#search'

  get '/ajaxsearch' => 'pages#ajaxsearch'

  # ---- AirKong ------
  get 'dashboard' => 'dashboards#index'

  resources :reservations, only: [:approve, :decline] do
    member do
     post '/approve' => "reservations#approve"
     post '/decline' => "reservations#decline"
    end
  end

  resources :revenues, only: [:index]

  resources :conversations, only: [:index, :create]  do
    resources :messages, only: [:index, :create]
  end



  get '/notifications' => 'notifications#index'

  mount ActionCable.server => '/cable'

  # オリジナル追加
  get 'about' => 'pages#about'

  get 'pages/management' => 'pages#management'
  get 'pages/guide' => 'pages#guide'
  get 'pages/legal' => 'pages#legal'
  get 'pages/rules' => 'pages#rules'
  get 'pages/policy' => 'pages#policy'
  get 'pages/host_flow' => 'pages#host_flow'
  get 'pages/guest_flow' => 'pages#guest_flow'
  get 'pages/qanda' => 'pages#qanda'

  get 'inquiry' => 'inquiry#index'
  get 'inquiry/confirm' => redirect("/inquiry")
  get 'inquiry/thanks' => redirect("/inquiry")
  post 'inquiry/confirm' => 'inquiry#confirm'
  post 'inquiry/thanks' => 'inquiry#thanks'

  get 'entry' => 'entry#index'
  get 'entry/confirm' => redirect("/entry")
  get 'entry/thanks' => redirect("/entry")
  post 'entry/confirm' => 'entry#confirm'
  post 'entry/thanks' => 'entry#thanks'

  get 'notice' => 'pages#notice'

  resources :fees, only: [:index]
end
