Rails.application.routes.draw do

  root 'session#create'
  resources :session do
     get 'forget_password', to: 'session#forget_password', on: :collection
     post 'reset_password', to: 'session#reset_password', on: :collection
     get 'change_password_view', to: 'session#change_password_view', on: :collection
     post 'change_password', to: 'session#change_password', on: :collection
  end
end
