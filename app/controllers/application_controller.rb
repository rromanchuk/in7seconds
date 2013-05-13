class ApplicationController < ActionController::Base
  protect_from_forgery
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

  def reconnect_with_facebook
    if current_user && current_user.facebook_token_expired?
      redirect_to user_omniauth_authorize_path(:facebook)
    end
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
