Rails.application.routes.draw do


  resources :posts, except: :show

  get "posts/:id" => "posts#read"

  root 'high_voltage/pages#show', id: 'home'

  devise_scope :user do
    get "settings" => "devise/registrations#edit", as: :settings
    get "find_password" => "devise/passwords#new", as: :find_password
    get "forgot_password" => "devise/passwords#new", as: :forgot_password
    get "resend" => "devise/confirmations#new", as: :resend
    post "auth/facebook" => "users/omniauth_callbacks#all"
    post "auth/linkedin" => "users/omniauth_callbacks#all"
    post "auth/google_oauth2" => "users/omniauth_callbacks#all"
    post "auth/twitter" => "users/omniauth_callbacks#all"
    post "auth/github" => "users/omniauth_callbacks#all"
  end

  devise_for :user, path: "",
             path_names: { sign_in: "login", sign_out: "logout", sign_up: "signup", password: "find_password" },
             controllers: {
                 :sessions => "users/sessions",
                 :registrations => "users/registrations",
                 :confirmations => "users/confirmations",
                 :omniauth_callbacks => "users/omniauth_callbacks"
             }



  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
