Rails.application.routes.draw do
  #resources :emails
  resources :mail
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
   root "mail#show"

   get '/recieve', to: 'mail#recieve'
   get '/reply', to: 'mail#reply'
   get '/clear', to: 'mail#clear_queuee'
end
