Rails.application.routes.draw do
  root to: 'articles#index'

  get '/articles/index_by_views' => 'articles#index_by_views'

  resources :articles do
    resources :comments
  end

  resources :tags
  resources :authors
  resources :author_sessions, only: [ :new, :create, :destroy ]

  get 'login'  => 'author_sessions#new'
  get 'logout' => 'author_sessions#destroy'

end
