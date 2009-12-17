ActionController::Routing::Routes.draw do |map|
  
  # Root route
  map.root :controller => "root"
  
  # Signup routes
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.forgot_password '/forgot_password', :controller => 'passwords', :action => 'new'
  map.change_password '/change_password/:reset_code', :controller => 'passwords', :action => 'reset'
  map.update_password '/update_password', :controller => 'passwords', :action => 'update_after_forgetting'

  # Restful routes
  map.resources :users do |user|
    user.resources :roles, :except => [:edit, :update]
  end
  map.resources :sessions, :only => [:create]
  map.resources :passwords
  
  map.resources :projects do |project|
    project.resources :commutes, :except => [:show]
    project.resources :deliveries, :except => [:show]
    project.resources :materials, :except => [:show]
    project.resources :energy_consumptions, :except => [:show]
    project.resources :wastes, :except => [:show]
  end
end