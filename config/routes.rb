ActionController::Routing::Routes.draw do |map|

  map.iphone '/iphone', :controller => "iphone"
  
  map.namespace :iphone do |iphone|
    iphone.resources :issues
    iphone.resources :projects
    iphone.resource  :timelog, :controller => "timelog", :collection => { :details => :get }  
  end

end

