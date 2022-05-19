class ApplicationController < ActionController::API

  def check_params_for_name
     render status: 400 if !params[:name] || params[:name] == ''
  end
end
