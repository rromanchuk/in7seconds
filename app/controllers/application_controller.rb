class ApplicationController < ActionController::Base
  protect_from_forgery
  #skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }
  helper_method :current_user_json
  before_filter :prepare_for_mobile

  def current_user
    @current_user ||= super && User.includes([:vk_country, :vk_city, :friends, :groups]).find(@current_user.id)
  end

  def current_user_json
    if current_user
      @user = current_user
      Rabl.render(current_user, 'api/v1/users/show', :view_path => 'app/views', :format => :json )
    else
      {}.to_json
    end
  end

  def broadcast(channel, data)
    message = {:channel => channel, :data => data, :ext => {:auth_token => FAYE_TOKEN}}
    uri = URI.parse(CONFIG[:faye_host])
    Net::HTTP.post_form(uri, :message => message.to_json)
  end

  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception, with: lambda { |exception| render_error 500, exception }
    rescue_from ActionController::RoutingError, ActionController::UnknownController, ::AbstractController::ActionNotFound, ActiveRecord::RecordNotFound, with: lambda { |exception| render_error 404, exception }
  end
  
  
  def mobile_device?
    if session[:mobile_param]
      session[:mobile_param] == "1"
    else
      request.user_agent =~ /Mobile|webOS/
    end
  end
  helper_method :mobile_device?

  def prepare_for_mobile
    session[:mobile_param] = params[:mobile] if params[:mobile]
    request.format = :mobile if mobile_device?
  end

  def render_error(status, exception)
    ExceptionNotifier::Notifier.exception_notification(request.env, exception).deliver
    respond_to do |format|
      format.html { render template: "pages/error_#{status}", layout: 'layouts/splash', status: status }
      format.all { render nothing: true, status: status }
    end
  end

end
