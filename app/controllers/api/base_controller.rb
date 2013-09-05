module Api
  class BaseController < ActionController::Base
    
    skip_before_filter :verify_authenticity_token, :if => Proc.new { |c| c.request.format == 'application/json' }
    #before_filter :miniprofile

    ADMINS = [41526347, 2048071, 4807674, 54267159, 201331745]
    FB_ADMINS = [225311, 7300784, 1071841049, 759795370, 3421601]

    # def miniprofile
    #   if current_user && (ADMINS.include?(current_user.vkuid) or FB_ADMINS.include?(current_user.fbuid)) 
    #     Rack::MiniProfiler.authorize_request
    #   end
    # end
    
    def current_user
      @current_user ||= super && User.includes([:vk_country, :vk_city, :friends, :groups]).find(@current_user.id)
    end
    
    def broadcast(channel, data)
      message = {:channel => channel, :data => data, :ext => {:auth_token => FAYE_TOKEN}}
      uri = URI.parse(CONFIG[:faye_host])
      Net::HTTP.post_form(uri, :message => message.to_json)
    end
  end
end