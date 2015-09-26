Rails.application.routes.draw do
  resources :orders
  resources :photos
  resources :groups

  mount_griddler
  root 'groups#new'
end
