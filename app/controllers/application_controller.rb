class ApplicationController < ActionController::API
  def check_params
     render json: { 'message': 'search params missing' }, status: 400 if !params[:name] || params[:name] == ''
  end
end
