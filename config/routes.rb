Ada::Application.routes.draw do
  match 'home', :to => 'inkling/home#dashboard', :as => "user_root"  
  match 'home', :to => 'inkling/home#dashboard', :as => "root"

  devise_scope :inkling_user do
    get "login", :to => "devise/sessions#new"
  end
  
  constraints Inkling::Routing::TypeConstraint.new("Page") do match '/*path' => "pages#show" end    
  
  namespace :staff do
    resources :pages
  end
end
