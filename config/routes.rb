Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"

    get "/home",    to: "static_pages#home", as: :home
    get "/help",    to: "static_pages#help", as: :help
    get "/contact", to: "static_pages#contact", as: :contact
    get "register", to: "users#new"
    post "register", to: "users#create"

    # resources :microposts (removed because no controller exists)
  end
end
