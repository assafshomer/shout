Shout::Application.routes.draw do
 resources :posts, only: [:new, :create,:show, :index]
 
 root to: "posts#new"
 
end
