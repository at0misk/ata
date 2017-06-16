Rails.application.routes.draw do
	root 'sessions#new'
	post 'users' => 'users#create'
	post 'sessions' => 'sessions#create'
	get '/requests/:id' => 'users#requests'
	get '/request_chat/:id' => 'users#request_chat'
	post 'topics' => 'topics#create'
	post '/topics/destroy' => 'topics#destroy'
	get '/topics/:id' => 'topics#view'
	post '/messages' => 'messages#create'
	get '/blogs/edit/:id' => 'blogs#edit'
	get '/blogs/new/:id' => 'blogs#new'
	post 'blogs' => 'blogs#create'
	post 'blogs/destroy' => 'blogs#destroy'
	patch '/blogs/:id' => 'blogs#update'
	get '/blogs/:id' => 'blogs#view'
	get '/subscriptions' => 'subscriptions#index'
	get '/subscriptions/:id' => 'subscriptions#subscribe'
	post '/subscriptions' => 'subscriptions#create'
	get '/cruises/new/:id' => 'cruises#new'
	post '/cruises' => 'cruises#create'
	get '/cruises/:id' => 'cruises#view'
	get '/specials/new/:id' => 'specials#new'
	post '/specials' => 'specials#create'
	get '/specials/:id' => 'specials#view'
	post 'contact' => 'users#contact'
	get '/gallery_upload/:username' => 'users#gallery_upload'
	get '/gallery/:username' => 'users#gallery'
	post '/gallery_upload' => 'users#photo_create'
	# ALL other routes must go above this --
	resources :users, param: :username, :path => '/'
	mount ActionCable.server => '/cable'
  	# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
