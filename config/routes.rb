Rails.application.routes.draw do
  post 'auth_user' => 'authentication#authenticate_user'
  get 'home' => 'home#index'
  post '/graphql', to: 'graphql#query'
  mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql" if Rails.env.development?
  devise_for :users
end
