Rails.application.routes.draw do
root 'games#new'

resources :users, only: [:new, :create, :destroy]
resources :games, only: [:new, :create, :show, :update]

get '/login' => 'sessions#new'
post '/login' => 'sessions#create'
get '/logout' => 'sessions#destroy'
get '/signup' => 'users#new'

get '/games/:id/hit' => 'games#hit'
get '/games/:id/hold' => 'games#hold'
get 'games/:id/over' => 'games#over'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
