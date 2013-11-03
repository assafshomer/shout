Shout::Application.routes.draw do
  get "static/home"
  get "static/help"
  get "static/about"
  get "static/contact"
  get "static/shapes"

 resources :posts
 
 root to: "static#home"

  match "/help",    to: 'static#help',          via: :get
  match "/about",   to: 'static#about',         via: :get
  match "/contact", to: 'static#contact',       via: :get
 	match "/shapes", 	to: 'static#shapes', 				via: :get

end
