class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :render_json
  #before_filter :prepare_for_mobile
  #before_filter :miniprofile


  # def miniprofile
  #   if current_user && (ADMINS.include?(current_user.vkuid) or FB_ADMINS.include?(current_user.fbuid)) 
  #     Rack::MiniProfiler.authorize_request
  #   end
  # end

  def current_user
    @current_user ||= super && User.includes([:vk_country, :vk_city, :friends, :groups]).find(@current_user.id)
  end

  def render_json(object, template)
    if current_user
      Rabl::Renderer.json(object, template, scope: self)
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

  # def prepare_for_mobile
  #   session[:mobile_param] = params[:mobile] if params[:mobile]
  #   request.format = :mobile if mobile_device?
  # end

  def render_error(status, exception)
    ExceptionNotifier::Notifier.exception_notification(request.env, exception).deliver
    respond_to do |format|
      format.html { render template: "pages/error_#{status}", layout: 'layouts/splash', status: status }
      format.all { render nothing: true, status: status }
    end
  end

end
