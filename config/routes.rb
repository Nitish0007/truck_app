Rails.application.routes.draw do
  require 'sidekiq/web'

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  Rails.application.routes.draw do 
    mount Sidekiq::Web => '/sidekiq'
  end

  namespace :api do
    namespace :v1 do
      # --------------------   ROUTES FOR AUTHENTICATION   -------------------- #
      devise_for :users,
      controllers: {
        registrations: 'api/v1/users/registrations',
        sessions: 'api/v1/users/sessions',
        passwords: 'api/v1/users/passwords'
      }

      devise_scope :api_v1_user do
        # sign_up route
        post 'users/sign_up', to: 'users/registrations#create'

        # sign_in route
        post 'users/sign_in', to: 'users/sessions#create'

        post 'users/forgot_password', to: 'users/passwords#create'

        # reset_password_success via mail link
        get 'users/password_reset_success', to: 'users#password_reset_success', as: 'password_reset_success'
      end

      
      # user routes
      get 'users/:user_id/drivers', to: 'users#index'
      get 'users/:user_id', to: 'users#show'
      put 'users/:user_id/update_profile', to: 'users#update'
      put 'users/:user_id/reset_password', to: 'users#reset_password'
      # ----------------------------------------------------------------------- #

      scope ':user_id' do
        resources :rides, except: [:new, :destroy, :edit]
        resources :trucks, except: [:new, :edit]
        resources :worksheets, except: [:new, :edit]
        resources :documents, only: [:create, :update, :destroy] do
          collection do
            post :get_upload_url
          end
          
          member do
            get :get_download_url
          end
        end
      end
      

    end
  end
end
