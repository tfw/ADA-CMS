Ada::Application.routes.draw do
  devise_for :users, :controllers => { :sessions => 'user_sessions' }
  
  match 'staff/home', :to => 'staff/home#dashboard', :as => "user_root"
  
  devise_scope :user do 
    get "login", :to => "user_sessions#new"    
    get "logout", :to => "user_sessions#destroy"
  end
  
  namespace :staff do
    resources :activity_logs, :only => :index
    resources :ddi_mappings
    resources :users, :only => [:index, :show]

    get 'site_resources', :to => "site_resources#index" #temporary 
    get 'hccda', :to => "hccda#index" #temporary 
    get 'adapt', :to => "adapt#index" #temporary 
    get 'usage-auditing', :to => "usage_auditing#index" #temporary 
    
    post 'archives/pages/sluggerize_path'
    post 'archives/pages/preview'
    post 'archives/update_page_order'

    resources :archives, :only => :show do
      resources :pages, :except => :index, :controller => "archives/pages" do
        collection do
          get 'browse'
        end
      end
      match '/integrations' => "archives/integrations#index"
      resources :archive_study_integrations, :except => [:index, :show], :controller => "archives/archive_study_integrations"
      resources :archive_study_blocks, :except => [:index, :show], :controller => "archives/archive_study_blocks"
      resources :archive_study_queries, :except => [:index, :show], :controller => "archives/archive_study_queries"
    end

    resources :news do
      post 'preview'
    end

    resources :documents, :images do
      collection do
        # Generate /staff/documents/browse -> browse_staff_documents, same for images
        get 'browse'
      end
    end
    
    get 'resources', :to => 'resources#index'
  end

  get '/search', :to => "search#search"  
  get 'browse_catalog', :to => "archive_catalogs#browse"
  
  inkling_match(:archive_studies)
  inkling_match(:archive_catalogs)
  inkling_match(:pages)
  inkling_match(:archive_news)
  inkling_match(:documents)
  inkling_match(:images)
  inkling_match("inkling/feeds")
  
  root :to => "pages#show_by_slug", :as => :root, :defaults => {:slug => "/ada/home"}
end

