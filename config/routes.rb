Ada::Application.routes.draw do
  match 'staff/home', :to => 'inkling/home#dashboard', :as => "user_root"  
  # match 'staff/home', :to => 'inkling/home#dashboard', :as => "root"

  devise_scope :inkling_user do
    get "login", :to => "devise/sessions#new"
  end

  match '/*path' => "pages#show", :as => :page, :constraints => Inkling::Routing::TypeConstraint.new("Page")
  
  namespace :staff do
    resources :pages      
    namespace :pages do 
      match 'update_tree' => '#update_tree', :as => :update_tree
    end
    match '/archives/:slug' => "archives#show", :as => "archives"
  end
  
  root :to => "pages#show_by_slug", :as => :root, :defaults => {:slug => "/ada-home"}
end

