Rails.application.routes.draw do
  resources :orders do
    member do
      put :complete
    end
  end
  resources :photos
  resources :groups

  match 'whatsapp', to: 'whatsapp#receive', via: :post

  mount_griddler
  root 'groups#new'
end
