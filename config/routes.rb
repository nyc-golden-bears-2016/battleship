Rails.application.routes.draw do
root 'games#new'

resources :users, only: [:new, :create, :destroy, :show, :index]
resources :games, only: [:new, :create, :show, :update]

get '/login' => 'sessions#new'
post '/login' => 'sessions#create'
get '/logout' => 'sessions#destroy'
get '/signup' => 'users#new'

get '/games/:id/hit' => 'games#hit'
get '/games/:id/hold' => 'games#hold'
get '/games/:id/over' => 'games#over'
post '/games/join' => 'games#join'
get '/games/:id/destroy/:ship_id' => 'games#destroy'

get '/games/:id/what_turn' => 'games#turn'

get 'games/:id/ships/new' => 'ships#new'
post 'games/:id/ships/create' => 'ships#create'


end
