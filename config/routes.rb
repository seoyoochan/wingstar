Rails.application.routes.draw do

  mount RedactorRails::Engine => '/redactor_rails'
  resources :locations
  resources :blogs, except: :show

  get "/comments/new/(:parent_id)", to: "comments#new", as: :new_comment
  post "/comments/new/(:parent_id)", to: "comments#create", as: :create_nested_comment

  resources :posts, except: :show do

    member do
      post "like", to: "posts#like", as: :like
      post "unlike", to: "posts#unlike", as: :unlike
      get ":slug", to: "posts#read", as: :read
      get ":slug/edit", to: "posts#edit"
      delete ":slug", to: "posts#destroy"
      patch ":slug", to: "posts#update"
      # get ":slug/comments", to: "comments#index", as: :post_comments
      post "comments", to: "comments#create", as: :comments_create
      delete "comments/:id", to: "comments#destroy", as: :comment_destroy
      get "comments/:id/edit", to: "comments#edit", as: :comment_edit
      patch "comments/:id", to: "comments#update", as: :comment
      put "comments/:id", to: "comments#update", as: :comment_update
      post "comments/like", to: "comments#like", as: :comment_like
      post "comments/unlike", to: "comments#unlike", as: :comment_unlike
      # get ":slug/comments/:id", to: "comments#show"

    end
    collection do
      delete 'destroy_multiple'
    end
  end

  get "post/:username/:id", to: "posts#read"

  scope :profile do
    get ":username" => "profile#show", as: :profile_show
    post ":username/cover" => "profile#cover", as: :profile_cover
    delete ":username/cover/destroy" => "profile#destroy", as: :profile_cover_destroy
  end

  get "blog/:username" => "blogs#show", except: :empty, as: :blog_show

  root :to => "application#index"

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
