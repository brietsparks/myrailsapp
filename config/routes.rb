Rails.application.routes.draw do
  devise_for :users
  namespace :api do
    namespace :v1 do
      get :dummy, to: "dummy#index"
      post :auth, to: "authentication#create"
    end
  end

  post '/graphql', to: 'graphql#query'
  mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql" if Rails.env.development?

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
