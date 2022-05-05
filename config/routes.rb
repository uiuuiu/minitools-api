Rails.application.routes.draw do
  devise_for :users,
    controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations',
      confirmations: 'users/confirmations'
    }, path: '/'
  
  devise_scope :user do
    post "/sign_up" => "users/registrations#create"
    post "/api/v1/social_auth/callback" => "api/v1/social_auth#authenticate_social_auth_user"
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      resources :shorted_links
      post 'public_shorted_links', to: 'public_shorted_links#create'
      mount_devise_token_auth_for 'User', at: 'auth', skip: [:omniauth_callbacks] # add this and overide the omniauth callbacks
      post 'social_auth/callback', to: 'social_auth#authenticate_social_auth_user' # this is the line where we add our routes
    end

    namespace :v2 do
      # resource :countries
    end
  end

  # Shorted link
  get '/r/:token' => "shorted_link_redirect#show"
end
