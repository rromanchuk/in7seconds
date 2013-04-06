class ApplicationController < ActionController::Base
  protect_from_forgery
  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }
  helper_method :current_user_json

  
  def current_user_json
    if current_user
      Rabl.render(current_user, 'users/show', :view_path => 'app/views', :format => :json)
    else
      {}.to_json
    end
  end

  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception, with: lambda { |exception| render_error 500, exception }
    rescue_from ActionController::RoutingError, ActionController::UnknownController, ::AbstractController::ActionNotFound, ActiveRecord::RecordNotFound, with: lambda { |exception| render_error 404, exception }
  end
  
  private
  def render_error(status, exception)
    respond_to do |format|
      format.html { render template: "pages/error_#{status}", layout: 'layouts/splash', status: status }
      format.all { render nothing: true, status: status }
    end
  end

end
