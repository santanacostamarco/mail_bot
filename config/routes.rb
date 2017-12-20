Rails.application.routes.draw do
  resources :mail
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "application#auth"

  get "/check", to: "application#check_for_mails"
end
