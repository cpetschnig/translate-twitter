TranslateTwitter::Application.routes.draw do

  root :to => 'showcase#index'

  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  #match ':username' => 'showcase#show_user'
end
