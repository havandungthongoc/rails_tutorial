Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home", as: :root

    get "/home",    to: "static_pages#home",    as: :home
    get "/help",    to: "static_pages#help",    as: :help
    get "/contact", to: "static_pages#contact", as: :contact

    get  "/register", to: "users#new",    as: :register
    post "/register", to: "users#create"

    get    "/login",  to: "sessions#new",    as: :login
    post   "/login",  to: "sessions#create", as: :sessions
    delete "/logout", to: "sessions#destroy", as: :logout

    resources :users
    get '/account_activations/:id/edit', to: 'account_activations#edit', as: :edit_account_activation
  end

  get "/", to: redirect("/vi")
end
