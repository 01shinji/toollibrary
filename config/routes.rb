Rails.application.routes.draw do

  root 'pages#home'

  devise_for :users,
             path: '',
             path_names: {sign_in: 'login', sign_out: 'logout', edit: 'profile', sign_up: 'registration'},
             controllers: {omniauth_callbacks: 'omniauth_callbacks', registrations: 'registrations'}

  resources :users, only: [:show]

  resources :listings, except: [:edit] do
    member do
      get 'information1'
      get 'information2'
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

  get '/payment_method' => "users#payment"
  get '/payout_method' => "users#payout"
  post '/add_card' => "users#add_card"

  get '/notifications' => 'notifications#index'

  mount ActionCable.server => '/cable'

  # オリジナル追加
  get 'about' => 'pages#about'
  get 'information' => 'pages#information'
end
