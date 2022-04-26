Rails.application.routes.draw do
  devise_for :users,
    controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations',
      confirmations: 'users/confirmations'
    }, path: '/'
  
  devise_scope :user do
    post "/sign_up" => "users/registrations#create"
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      resources :shorted_links
    end

    namespace :v2 do
      # resource :countries
    end
  end

  # Shorted link
  get '/r/:token' => "shorted_link_redirect#show"
end
