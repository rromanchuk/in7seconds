In7seconds::Application.routes.draw do
  resources :token_authentications, :only => [:create, :destroy]

  devise_for :users,
             :controllers => { :registrations => "users/registrations",
                               :confirmations => "users/confirmations",
                               :sessions => 'devise/sessions',
                               :omniauth_callbacks => "users/omniauth_callbacks"},
             :skip => [:sessions] do
    get '/'   => "pages#index",       :as => :new_user_session
    get '/signout'  => 'devise/sessions#destroy',  :as => :signout
  end

  resources :relationships do
    collection do
      post :flirt
      post :reject
    end
  end

  match '/users/unsubscribe/:signature' => 'users#unsubscribe', as: 'unsubscribe'

  resources :users do
    resources :images
    resources :messages do
      collection do
        get :thread
      end
    end
    member do
      post :flirt
      post :reject
    end

    collection do
      get :me
      put :update_user
      get :feed
      get :hookups
      get :matches
    end
  end

  # config/routes.rb
  if Rails.env.development?
    mount MailPreview => 'mail_view'
  end

  get 'about' => 'pages#about'
  get 'tos' => 'pages#tos'
  get 'exception' => 'pages#exception'

  # fixme
  get 'matches' => 'pages#matches'
  get 'profile' => 'pages#profile'

  get 'feed' => 'users#feed'

  root :to => 'users#home'
end
