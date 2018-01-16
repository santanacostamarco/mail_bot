Rails.application.routes.draw do


  #get 'users/new'

  #get 'sessions/new'

  #resources :emails

  root 'mail#index'

  resources :mail
  resources :mail_pop
  resources :mail_imap
  resources :users
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
   get '/emails', to: "mail#show"
   get '/imap_recieve', to: 'mail_imap#recieve'
   get '/pop_recieve', to: 'mail_pop#recieve'
   get '/reply', to: 'mail#reply'
   get '/clear', to: 'mail#clear_queuee'

   get '/usuarios', to: 'users#show'
   get '/cadastrar', to: 'users#new'
   post '/cadastrar', to: 'users#create'

   get '/login', to: 'sessions#new'
   post '/login', to: 'sessions#create'
   delete '/logout', to: 'sessions#destroy'
   
end
