NmdAlumni::Application.routes.draw do

  devise_for :users
  root to:  "main#index"

  get "admin" => "admin#index", as: :admin
  get "admin/tasks" => "admin#tasks", as: :admin_tasks
  post "admin/perform_task" => "admin#perform_task"

  resources :members
  resources :expertise_areas
  resources :engagement_types

  resources :site_options, only: [] do
    collection do
      get :edit
      put :update
    end
  end

  resources :student_invites do
    member do
      get :send_invite
    end

    collection do
      get :send_invite
      post :upload
      get :delete_multiple
    end
  end

  resources :backgrounds do
    collection do
      get :search
    end
  end

  resources :organisations do
    collection do
      get :search
    end
  end

  resources :places do
    collection do
      get :search
    end
  end

  resources :students

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
