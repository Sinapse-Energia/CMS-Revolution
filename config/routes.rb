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
  get '/logout', to: "session#logout"
  get '/device_mqtt', to: "devices#device_mqtt"
  get '/create_device', to: "devices#create_device"
  get '/get_device', to: "devices#get_device" 

  resources :devices do
    member do
      get :get_device
      get :get_messages
      post :connect
      post :disconnect
    end
  end

  resources "mqtt_connection", module: "mqtt"  do        
    get :connect,  on: :collection
    get :disconnect,  on: :collection
    get :publishing,  on: :collection
    get :subscribe,  on: :collection
  end
  
end
