Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  root to: 'pages#front'
  get 'home', to: 'videos#index'

  get 'register', to: 'users#new'
  
  get 'sign-out', to: 'sessions#destroy',  as: 'sign_out'
  get 'sign-in', to: 'sessions#new', as: 'sign_in'
  post 'sign-in', to: 'sessions#create'

  resources :users, only: [:create, :edit, :update]

  resources :videos, except:[:destroy, :index] do
    collection do
      get 'search', to: 'videos#search'
    end
  end

  resources :categories

end
