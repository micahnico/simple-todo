Rails.application.routes.draw do

  root 'projects#index'

  resources :projects, except: [:show] do
    member do
      post :toggle_archive
    end

    resources :lists, except: [:show] do
      resources :todos, except: [:show] do
        member do
          post :toggle_complete
        end
      end
    end
  end

  resources :labels

  resource :session, only: %i[new create destroy]
  get 'password_reset/:id/:token/edit' => 'password_resets#edit', as: :edit_password_reset
  patch 'password_reset/:id/:token' => 'password_resets#update', as: :password_reset
  resources :password_reset_authorizations, only: %i[new create]
  resource :registration, except: %i[index]

end
