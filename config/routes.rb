Rails.application.routes.draw do
  resources :documents, only: [:new, :create, :show]
  root "documents#new"
end
