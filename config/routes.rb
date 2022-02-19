Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resource :user, only: %i[create]
      resource :session, only: %i[create destroy]
      resources :projects, shallow: true, only: %i[create update destroy] do
        resources :tasks, only: %i[create update destroy] do
          resources :comments, only: %i[create]
        end
      end
    end
  end
end
