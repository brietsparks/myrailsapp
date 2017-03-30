class GraphqlController < ApiController
  skip_before_action :authenticate_user!

  def show
    render json: {foo: 'bar'}
  end

  def query
    variables = params[:variables]
    variables = JSON.parse(variables) if variables && variables.is_a?(String)

    result_hash = Schema.execute(params[:query], variables: variables)
    render json: result_hash
  end
end