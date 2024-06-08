Rails.application.routes.draw do
  resources :pdf_documents, only: [:new, :create, :show]
  root 'pdf_documents#new'
end
