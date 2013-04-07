In7seconds::Application.routes.draw do
  
  resources :token_authentications, :only => [:create, :destroy]


  devise_for :users,
             :controllers => { :registrations => "users/registrations",
                               :confirmations => "users/confirmations",
                               :sessions => 'devise/sessions',
                               :omniauth_callbacks => "users/omniauth_callbacks"},
             :skip => [:sessions] do
    get '/'   => "pages#index",       :as => :new_user_session
    get '/signout'  => 'devise/sessions#destroy',   :as => :destroy_user_session
  end

  resources :relationships do 
    collection do 
      post :flirt
      post :reject
    end
  end

  match '/users/unsubscribe/:signature' => 'users#unsubscribe', as: 'unsubscribe'


  resources :users do 
    resources :messages
    member do 
      post :flirt
      post :reject
    end
    
    collection do 
      get :me
      put :update_user
      get :feed
    end
  end


  # config/routes.rb
  if Rails.env.development?
    mount MailPreview => 'mail_view'
  end
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  get 'about' => 'pages#about'
  get 'tos' => 'pages#tos'


  get 'feed' => 'users#feed'

 
  root :to => 'users#home'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
