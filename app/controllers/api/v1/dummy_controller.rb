class Api::V1::DummyController < ApiController
  def index
    render json: {'foo': 'bar'}
  end
end