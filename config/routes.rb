Rails.application.routes.draw do
  post "/graphql", to: "graphql#execute"
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resource :user, only: %i[create]
      resource :session, only: %i[create destroy]
      resources :archived_tasks, only: %i[index]
      resources :projects, shallow: true, except: %i[show] do
        resources :tasks, only: %i[create update destroy] do
          resources :comments, only: %i[create destroy]
        end
      end
    end
  end
end
