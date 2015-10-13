Rails.application.routes.draw do
  resources :orders
  resources :photos
  resources :groups

  match 'whatsapp', to: 'whatsapp#receive', via: :all

  mount_griddler
  root 'groups#new'
end
