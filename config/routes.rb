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
  get 'register/:invite_token', to: 'users#new_with_invitation', as: 'register_invite'
  resources :users, only: [:index, :create, :edit, :update, :show]
  get 'used_token', to: 'users#used_token'

  resources :followings, only: [:create, :destroy]
  get 'people', to: 'followings#index'

  resources :invites, path: 'invite-friend', only: [:new, :create]

  get 'sign-out', to: 'sessions#destroy',  as: 'sign_out'
  get 'sign-in', to: 'sessions#new', as: 'sign_in'
  post 'sign-in', to: 'sessions#create'

  get 'password_reset', to: 'password_resets#new'
  post 'password_reset', to: 'password_resets#create'
  get 'password_reset/:password_reset', to: 'password_resets#edit', as: 'edit_password_reset'
  patch 'password_reset/:password_reset', to: 'password_resets#update', as: 'update_password_reset'

  get 'confirm_password_reset', to: 'password_resets#confirm_password_reset'
  get 'invalid_token', to: 'password_resets#invalid_token'

  root to: 'pages#front'
  get 'home', to: 'videos#index'

  get 'ui(/:action)', controller: 'ui'

end
