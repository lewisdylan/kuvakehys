Rails.application.routes.draw do
  resources :groups

  namespace :admin do
    resources :orders, only: [:index, :show, :edit, :update, :destroy] do
      member do
        put :submit
        put :prepare
      end
    end
    resources :photos
    resources :groups do
      resources :orders, only: [:create]
    end
    resources :users, only: [:index, :show]
    root 'groups#index'
  end

  match 'whatsapp', to: 'chat_sessions#whatsapp', via: :post
  match 'telegram', to: 'chat_sessions#telegram', via: :post

  mount_griddler
  root 'pages#home'
end
