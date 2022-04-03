Rails.application.routes.draw do
  
  get 'event/index'
  post 'event/create', to: 'events#create'
  post 'event/update', to: 'events#update'

  get 'event/:category', to: 'events#category'
  get 'event/:id', to: 'events#show', constraint: { id: /\d+/ }
  
  post 'bet', to: 'bets#make_bet'

  get 'users', to: 'users#index'

  get 'user/new', to: 'users#new'
  post 'user/create', to: 'users#create'

  get 'user/login', to: 'users#login'
  post 'user/login', to: 'users#login_post'

  get 'my-account/:id', to: 'users#account'

  get 'deposit/:id', to: 'users#deposit'
  post 'deposit', to: 'users#make_deposit'

  get 'withdraw/:id', to: 'users#withdraw'
  post 'withdraw', to: 'users#make_withdraw'

  get 'my-bets/:id', to: 'users#mybets'
  get 'statement/:id', to: 'users#statement'
  
  root to: 'events#index'
end
