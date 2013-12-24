Goschool::Application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'

  get "search_engine/search"

  controller :teachers do
    get 'teachers'=>:index
    get 'teachers/index'
    get 'teachers/schedules'
    get 'teachers/fast_search'
  end

  controller :tags do
    get 'tags/fast_search'
  end

  resources :student_homeworks

  resources :homeworks do
    collection do
      get  'index/:id'=>:index
      get  'index/:id/:sid'=>:index #sid is sub_course_id
      get 'list/:id/:type'=>:list
      get 'list/:id/:type/:sid'=>:list
    end
  end

  resources :consultcomments

  resources :achievements do
    collection do
      post :create_sub
      get :sub_achievement
    end
  end
  resources :achievementresults

  resources :welcome
  root :to => 'welcome#index'
  
  resources :comments
  resources :posts do
    collection do
      get 'index/:id'=>:index
      get 'list/:id/:type'=>:list
    end
  end

  controller :files do
    post 'files/attach'=>:attach
    post 'files/remove_attach' =>:remove_attach
    get 'files/download'=>:download
  end

  resources :student_courses do
    collection do
      post :creates
      put :pay
      put :pays
      delete :destroies
    end
  end

  resources :schedules do
    collection do
      get :dates
      get :courses
      get :teachers
      post :send_email
    end
  end

  resources :students do
    collection do
      get :fast_search
      get ':id/edit'=>:edit
      get ':id/:part'=>:show
      get ':id/:part/:ajax'=>:show
      get 'detail/:id'=>:detail
    end
  end

  resources :student

  resources :teacher_courses

  resources :sub_courses do
    collection do
      get :teachers
    end
  end

  resources :courses do
    collection do
      get ':id/edit'=>:edit
      get ':id/:part'=>:show
      get ':id/:part/:ajax'=>:show
      get :fast_search
      get :list_search
      get :subs
      post :add_teacher
      get :detail
    end
  end

  resources :settings do
    collection do
      get ':id/:ajax'=>:show
      put :update
    end
  end
  resources :institutions
  mount Resque::Server.new, :at=>"/admin/resque"

  resources :users do
    collection do
      get :schedules
      get :teacher
    end
  end
  resources :custom_views
  resources :logininfos
  resource :subscriptions

  resources :consultations

  resource :logininfo_sessions
  controller :logininfo_sessions do
    match 'logininfo_sessions/destroy' => :destroy
  end

  controller :attachments do
    match 'attachments/:id' => :destroy, :via => "delete"
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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
