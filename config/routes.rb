Rails.application.routes.draw do
  devise_for :users
  namespace :api do
    namespace :v1 do
      post :auth, to: "authentication#create"
    end
  end

  post '/graphql', to: 'graphql#query'
  mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql" if Rails.env.development?

  # post 'auth_user' => 'authentication#authenticate_user'
  get 'home' => 'home#index'
end
