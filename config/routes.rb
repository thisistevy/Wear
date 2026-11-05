Rails.application.routes.draw do
  devise_for :users

  resources :scans, only: [:new, :create]
  get 'aboutus', to: 'pages#aboutus'
  get 'info', to: 'pages#info'
  # The map is the landing page: it is the one screen that shows what the app
  # is for (stores, collection and recycling points near you) without asking
  # anyone to sign in first. The former home page now lives at /info.
  root to: 'maps#index'

  resources :products, only: %i[index show], shallow: true do
    resources :feedbacks, only: %i[create show]
  end

  resources :favorites, only: %i[index create destroy]
  resources :brands, only: %i[index show]
  resources :listings
  # The map moved to the root. Keep the old path working so bookmarks and
  # pages still cached in a browser don't 404.
  get 'map', to: redirect('/')
end
