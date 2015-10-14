Rails.application.routes.draw do
  resources :groups

  namespace :admin do
    resources :orders, only: [:index, :show, :edit, :update, :destroy] do
      member do
        put :complete
      end
    end
    resources :photos
    resources :groups
    resources :users, only: [:index, :show]
    root 'groups#index'
  end

  match 'whatsapp', to: 'whatsapp#receive', via: :post

  mount_griddler
  root 'groups#new'
end
