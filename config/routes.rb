Rails.application.routes.draw do

  scope "(:locale)", locale: /en|vi/ do
    resources :users, only: [:index, :new, :create, :show]
  end

  root "static_pages#home"

  get "/home",    to: "static_pages#home"
  get "/help",    to: "static_pages#help"
  get "/contact", to: "static_pages#contact"

  resources :microposts
end
