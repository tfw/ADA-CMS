Ada::Application.routes.draw do
  # match 'staff/home', :to => 'inkling/home#dashboard', :as => "user_root"  
  match 'staff/home', :to => 'staff/home#dashboard', :as => "user_root"  
  
  devise_scope :inkling_user do
    get "login", :to => "devise/sessions#new"
    get "logout", :to => "devise/sessions#destroy"
  end
    
  namespace :staff do
    resources :activity_logs, :only => :index
    post 'archives/pages/sluggerize_path'
    post 'archives/pages/preview'    
    post 'archives/update_page_order'
    
    resources :archives, :only => :show do
      resources :pages, :except => :index, :controller => "archives/pages"
      match '/integrations' => "archives/integrations#index"  
      resources :archive_study_integrations, :except => [:index, :show], :controller => "archives/archive_study_integrations"
      resources :archive_study_blocks, :except => [:index, :show], :controller => "archives/archive_study_blocks"
      resources :archive_study_queries, :except => [:index, :show], :controller => "archives/archive_study_queries"
    end
  end
  
  match '/*path' => "archive_studies#show", :as => :archive_study, :constraints => Inkling::Routing::TypeConstraint.new("ArchiveStudy")
  match '/*path' => "pages#show", :as => :page, :constraints => Inkling::Routing::TypeConstraint.new("Page")
  root :to => "pages#show_by_slug", :as => :root, :defaults => {:slug => "/ada/home"}
end

