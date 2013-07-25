module Api
  class BaseController < ActionController::Base
    protect_from_forgery
    skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }
    
    def current_user
      @current_user ||= super && User.includes([:vk_country, :vk_city, :friends, :groups]).find(@current_user.id)
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
  end 

end