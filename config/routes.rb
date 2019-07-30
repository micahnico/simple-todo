Rails.application.routes.draw do

  root 'projects#index'

  resources :projects, except: [:show] do
    resources :lists, except: [:show] do
      resources :todos, except: [:show] do
        member do
          post :toggle_complete
        end
      end
    end
  end

end
