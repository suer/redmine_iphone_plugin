ActionController::Routing::Routes.draw do |map|

  map.iphone '/iphone', :controller => "iphone"
  
  map.namespace :iphone do |iphone|
    iphone.resources :projects , :member => { :activity => :get } do |project|
      project.resources :issues
    end
    iphone.resource  :timelog, :controller => "timelog", :collection => { :details => :get }  
  end

end

