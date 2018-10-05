Rails.application.routes.draw do

  root 'session#index'
  resources :session do
  	get 'index', to: 'session#index', on: :collection
  	post 'create', to: 'session#create_session', on: :collection
  	get 'register', to: 'session#register', on: :collection
  	post 'create_register', to: 'session#create_register', on: :collection
    get 'forget_password', to: 'session#forget_password', on: :collection
    post 'reset_password', to: 'session#reset_password', on: :collection
    get 'change_password_view', to: 'session#change_password_view', on: :collection
    post 'change_password', to: 'session#change_password', on: :collection
  end
end
