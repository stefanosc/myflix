Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  root to: 'videos#index'
  get 'home', to: 'videos#index' 

  resources :videos, except:[:destroy, :index] do
    collection do
      get 'search', to: 'videos#search'
    end
  end

  resources :categories

end
