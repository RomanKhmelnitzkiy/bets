Rails.application.routes.draw do
  
  get 'event/index'

  get 'event/new', to: 'events#new'
  post 'event/create', to: 'events#create'
  post 'event/update', to: 'events#update'

  get 'event/:category', to: 'events#category'
  #get 'event/:id', to: 'events#show', constraint: { id: /\d+/ }
  
  get 'bet', to: 'bets#new'
  post 'bet', to: 'bets#make_bet'

  get 'users', to: 'users#index'

  get 'user/new', to: 'users#new'
  post 'user/create', to: 'users#create'

  get 'user/login', to: 'sessions#new'
  post 'user/login', to: 'sessions#create'
  post 'user/logout', to: 'sessions#destroy'

  get 'my-account', to: 'users#account'

  get 'deposit', to: 'users#deposit'
  post 'deposit', to: 'users#make_deposit'

  get 'withdraw', to: 'users#withdraw'
  post 'withdraw', to: 'users#make_withdraw'

  get 'my-bets/', to: 'users#mybets'
  get 'statement', to: 'users#statement'
  
  root to: 'events#index'
end
