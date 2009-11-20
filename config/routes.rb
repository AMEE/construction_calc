ActionController::Routing::Routes.draw do |map|
  
  # Root route
  map.root :controller => "root"
  
  # Signup routes
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.activate '/activate/:activation_code', :controller => 'users', :action => 'activate', :activation_code => nil
  map.forgot_password '/forgot_password', :controller => 'passwords', :action => 'new'
  map.change_password '/change_password/:reset_code', :controller => 'passwords', :action => 'reset'
  map.update_password '/update_password', :controller => 'passwords', :action => 'update_after_forgetting'

  # Restful routes
  map.resources :users
  map.resources :passwords
  map.resource :session
  map.resources :units, :only => [:index]
  
  map.resources :projects do |project|
    project.resources :commutes
  end
end