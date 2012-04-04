InfoReminder::Application.routes.draw do
  # Groups
  resources :groups do
    collection do 
      get :manage
    end
    resources :events
    resources :categories
  end
  match 'search/(:query)/(:page)' => 'groups#search', :as => 'search_groups'

  # Invitations and membership management
  match 'invite(.:format)/:group_id/(:user_id)' => 'membership#invite', :as => 'invite_to_group'
  match 'confirm/join/:id/(:activation_code)' => 'membership#confirm_join', :as => 'confirm_join_group'
  match 'join/:id/(:activation_code)' => 'membership#join', :as => 'join_group'
  match 'leave/:id' => 'membership#leave', :as => 'leave_group'

  match 'events(.:format)' => 'events#upcoming', :as => 'upcoming_events'
  
  # Setup builder service
  match 'setup/download' => 'setup#prepare', :as => 'prepare_setup'
  match 'setup/status/:id' => 'setup#status', :as => 'setup_status'
  match ':id/info-reminder-setup.exe' => 'setup#download', :as => 'download_setup'

  # Exposed api to third-party apps (like desktop app)
  match 'client/:action(.:format)/(:user_id/:auth_token)' => 'client'

  # User profile rules
  match 'settings' => 'settings#show', :as => 'show_settings'
  match 'settings/:action(.:format)' => 'settings'
  devise_for :users

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
  root :to => 'home#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
