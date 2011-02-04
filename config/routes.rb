ActionController::Routing::Routes.draw do |map|

  map.root :controller => :main, :action => :index
  map.about 'about',       :controller => :main,          :action => :about
  map.feedback 'feedback', :controller => :main,          :action => :feedback
  map.help 'help',         :controller => :main,          :action => :help
  map.mobile 'mobile',     :controller => :mobile,        :action => :index
  map.login 'login',       :controller => :user_sessions, :action => :new
  map.logout 'logout',     :controller => :user_sessions, :action => :destroy

  map.resources :user_sessions, :enrollments
 
  map.resources :users, :requirements => {:id => /[^\?\/]+/} do |user|
    user.resources :ratings, :iratings
    user.schools 'schools', :controller => :schools, :action => :index_user, :requirements => { :user_id => /([^\/?]+)/ }
    user.posts     'posts', :controller => :posts,   :action => :index_user, :requirements => { :user_id => /([^\/?]+)/ }
  end

  map.resources :schools, :except => [:show, :update, :edit] do |school| # path_prefix, as
    school.resources :departments, :path_prefix => ':school_id' #, :except => :destroy
    school.resources :courses, :only => :create
    school.enroll   'enroll',   :path_prefix => ':id', :controller => :schools, :action => :enroll
    school.unenroll 'unenroll', :path_prefix => ':id', :controller => :schools, :action => :unenroll
  end
  
  map.school      ':id',      :controller => :schools, :action => :show, :conditions => { :method => :get }
  map.connect     ':id',      :controller => :schools, :action => :update, :conditions => { :method => :put }
  map.edit_school ':id/edit', :controller => :schools, :action => :edit

  map.course      ':school_id/:id/:term:year',      :controller => :courses, :action => :show,   :conditions => { :method => :get }, :requirements => { :term => /../, :year => /\d\d/ }
  map.connect     ':school_id/:id/:term:year',      :controller => :courses, :action => :update, :conditions => { :method => :put }, :requirements => { :term => /../}
  map.edit_course ':school_id/:id/:term:year/edit', :controller => :courses, :action => :edit,   :requirements => { :term => /../ }

  map.resources :courses, :except => [:show], :path_prefix => ':school_id' do |course|#:collection => {:auto_complete_for_department_name => :get } do |course|
    course.info        'info',        :controller => :courses, :action => :info,        :path_prefix => ':school_id/:id/:term:year', :requirements => {:term => /../, :year => /\d\d/}
    course.subscribe   'subscribe',   :controller => :courses, :action => :subscribe,   :path_prefix => ':school_id/:id/:term:year', :requirements => {:term => /../, :year => /\d\d/}
    course.unsubscribe 'unsubscribe', :controller => :courses, :action => :unsubscribe, :path_prefix => ':school_id/:id/:term:year', :requirements => {:term => /../, :year => /\d\d/}
    course.resources :grades,  :path_prefix => ':school_id/:course_id/:term:year', :requirements => {:term => /../, :year => /\d\d/}
    course.resources :ratings, :path_prefix => ':school_id/:course_id/:term:year', :requirements => {:term => /../, :year => /\d\d/}
    # :requirements is for items with periods in them ex. Chapter 2.1 Questions
    course.resources :items,   :path_prefix => ':school_id/:course_id/:term:year', :requirements => {:id => /[^\?\/]+/, :term => /../, :year => /\d\d/} do |item|
      item.ajaxupdate 'posts/update_results', :controller => :posts, :action => :update_results, :method => :get, :requirements => {:item_id => /[^\?\/]+/}
      item.resources :iratings, :requirements => {:item_id => /[^\?\/]+/}
      item.resources :posts,    :requirements => {:item_id => /[^\?\/]+/, :term => /../, :year => /\d\d/} do |post|
        post.reply 'reply', :controller => :posts, :action => :new_post_reply, :requirements => {:item_id => /[^\?\/]+/}
      end
    end
  end
  
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  # map.connect ':controller/destroy/:id', :action => :index
  # map.connect ':controller/destroy/:id.:format', :action => :index
  # map.connect ':controller/:action/:id'
  # map.connect ':controller/:action/:id.:format'
end
