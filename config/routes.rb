Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  root "home#index"
  get "/about" => "home#about"

  resources :users, only:[:new, :create, :edit, :update]
  resource :sessions, only: [:new, :create] do
    delete :destroy, on: :collection
  end

  get "/changepassword" => "users#change_password", as: :change_password
  patch "/changepassword" => "users#update_password"


  resources :password_resets, only: [:new, :create, :edit, :update]
  # get "/password_resets" => "users#reset_password", as: :reset_password
  # patch "/password_resets" => "users#password_reset"

  resources :posts do
    get :search, on: :collection
    post :flag, on: :member
    post :mark_done
    resources :comments, only: [:create, :edit, :destroy, :update]
    resources :favourites, only:[:create, :destroy]
  # get "/posts/new" => "posts#new", as: :new_post
  # post "/posts" => "posts#create", as: :posts
  # get "/posts" => "posts#index"
  # get "/posts/:id" => "posts#show", as: :post
  # get "/posts/:id/edit" => "posts#edit", as: :edit_post
  # patch "/posts/:id/" => "posts#update"
  # delete "/posts/:id" => "posts#destroy"
  end
  get "/posts/search" => "posts#search"
  post "/posts/search" => "posts#search", as: :search

  resources :favourites, only:[:index]

end


  # resources :comments
  # get "/comments/new" => "comments#new", as: :new_comment
  # post "/comments" => "comments#create", as: :comments
  # get "/comments" => "comments#index"
  # get "/comments/:id" => "comments#show", as: :comment
  # get "/comments/:id/edit" => "comments#edit", as: :edit_comment
  # patch "/comments/:id/" => "comments#update"
  # delete "/comments/:id" => "comments#destroy"

  # delete "/posts/:id" => "posts#destroy"
  # You can have the root of your site routed with "root"
  # root 'welcome#index'
