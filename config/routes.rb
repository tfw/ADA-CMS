Ada::Application.routes.draw do
  match 'staff/home', :to => 'inkling/home#dashboard', :as => "user_root"  

  devise_scope :inkling_user do
    get "login", :to => "devise/sessions#new"
    get "logout", :to => "devise/sessions#destroy"
  end
  
  
  namespace :staff do
    resources :activity_logs, :only => :index

    resources :pages, :except => :index
    post 'pages/sluggerize_path'
    post 'pages/preview'
    
    # namespace :pages do 
    #   match 'update_tree' => '#update_tree', :as => :update_tree
    #   match 'sluggerize_path' => '#sluggerize_path', :as => :sluggerize_path
    # end
    post '/archives/update_page_order'
    match '/archives/:slug' => "archives#show", :as => "archives"
  end
  
  match '/*path' => "pages#show", :as => :page, :constraints => Inkling::Routing::TypeConstraint.new("Page")
  root :to => "pages#show_by_slug", :as => :root, :defaults => {:slug => "/ada-home"}
end

