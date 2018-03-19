Rails.application.routes.draw do
  resources "carts", only: %i[show] do
    resources "cart_items", only: %i[create update destroy], as: :items
  end
  
  resources "checkouts", only: %i[show edit update]

  devise_for :users
  resources "users", only: %i[index show destroy]
  resources "events", "items" do
    resources "comments", only: %i[create destroy]
  end
  root "application#home"
  get "/home", to: "application#home", as: "home"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
