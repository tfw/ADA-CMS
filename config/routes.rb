Ada::Application.routes.draw do
  devise_for :users, :controllers => { :sessions => 'user_sessions' }

  match 'staff/home', :to => 'staff/home#dashboard', :as => "inkling_user_root"

  namespace :staff do
    resources :activity_logs, :only => :index
    resources :ddi_mappings
    resources :users, :only => [:index, :show]

    get 'site_resources', :to => "site_resources#index" #temporary 
    # get 'users', :to => "users#index" #temporary 
    get 'hccda', :to => "hccda#index" #temporary 
    get 'adapt', :to => "adapt#index" #temporary 
    get 'usage-auditing', :to => "usage_auditing#index" #temporary 
    
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
    resources :news
  end

  get '/search', :to => "search#sphinx"

  inkling_match(:archive_studies)
  inkling_match(:pages)
  inkling_match(:news)
  
  root :to => "pages#show_by_slug", :as => :root, :defaults => {:slug => "/ada/home"}
end

