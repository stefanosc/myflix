Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  root to: 'pages#front'
  get 'home', to: 'videos#index'

  get 'register', to: 'users#new'

  get 'sign-out', to: 'sessions#destroy',  as: 'sign_out'
  get 'sign-in', to: 'sessions#new', as: 'sign_in'
  post 'sign-in', to: 'sessions#create'

  resources :users, only: [:create, :edit, :update]

  resources :queue_items, path: 'my-queue' , only: [:index, :create, :destroy]
  post 'update-queue', to: 'queue_items#update_queue', as: 'update_queue'

  resources :videos, except:[:destroy, :index] do
    collection do
      get 'search', to: 'videos#search'
    end
    resources :reviews, only:[:create]
  end

  post 'remove-review', to: 'reviews#destroy_review', as: 'destroy_review'

  resources :categories, only: [:index, :show]

end
