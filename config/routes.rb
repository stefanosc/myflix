Myflix::Application.routes.draw do

  resources :videos, except:[:destroy, :index] do
    collection do
      get 'search', to: 'videos#search'
    end
    resources :reviews, only:[:create]
  end
  post 'remove-review', to: 'reviews#destroy', as: 'destroy'

  resources :categories, only: [:index, :show]

  resources :queue_items, path: 'my-queue' , only: [:index, :create, :destroy]
  post 'update-queue', to: 'queue_items#update_queue', as: 'update_queue'

  get 'register', to: 'users#new'
  resources :users, only: [:index, :create, :edit, :update, :show]

  resources :followings, only: [:create, :destroy]
  get 'people', to: 'followings#index'

  get 'sign-out', to: 'sessions#destroy',  as: 'sign_out'
  get 'sign-in', to: 'sessions#new', as: 'sign_in'
  post 'sign-in', to: 'sessions#create'

  get 'password_reset', to: 'password_resets#new'
  post 'password_reset', to: 'password_resets#create'
  get 'password_reset/:password_reset', to: 'password_resets#edit', as: 'edit_password_reset'
  patch 'password_reset/:password_reset', to: 'password_resets#update', as: 'update_password_reset'

  root to: 'pages#front'
  get 'home', to: 'videos#index'

  get 'ui(/:action)', controller: 'ui'

end
