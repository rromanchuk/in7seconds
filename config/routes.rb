In7seconds::Application.routes.draw do
  
  devise_for :users,
             :controllers => { :registrations => "users/registrations",
                               :sessions => 'devise/sessions',
                               :omniauth_callbacks => "users/omniauth_callbacks"},
             :skip => [:sessions] do
    get '/'   => "pages#index",       :as => :new_user_session
  end

  devise_scope :user do
    match "/logout" => "devise/sessions#destroy",  via: [:get, :post]
  end



  match '/users/unsubscribe/:signature' => 'users#unsubscribe', as: 'unsubscribe', via: [:get, :post]
  

  namespace :admin do
    resources :notifications
    resources :users do 
      collection do
        get :stats
      end
      member do
        post :flirt
        post :send_pending_reminder
        post :send_notification
      end
    end
  end

  namespace :api do
    namespace :v1 do
      resources :token_authentications, :only => [:create, :destroy]
      resources :images
      resources :notifications do
        collection do
          post :mark_as_read
        end
      end
      
      resources :messages do
        collection do
          get :all_threads
          post :create_new
        end
      end
        
      
      resources :users do
        resources :messages do
          collection do
            get :thread
            post :create_new
          end
        end
        member do
          post :flirt
          post :reject
        end

        collection do
          get :me
          get :authenticated_user
          put :update_user
          get :feed
          get :hookups
          get :matches
        end
      end
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

  root :to => 'pages#index'
end
