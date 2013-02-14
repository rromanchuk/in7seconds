class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    # You need to implement the method below in your model
    auth = request.env["omniauth.auth"]
    facebook_user =  FbGraph::User.fetch(auth.uid, :access_token => auth.credentials.token)
    @user = User.find_or_create_for_facebook_oauth(facebook_user, current_user)
    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def vkontakte
    auth = request.env["omniauth.auth"]
    puts auth.to_yaml
    vk = VkontakteApi::Client.new(auth.credentials.token)
    fields = [:first_name, :last_name, :screen_name, :bdate, :city, :country, :sex, :photo_big]
    vk_user = vk.users.get(uid: params[:user_id], fields: fields).first
    #vk_user.merge!(email: params[:email])
    @user = User.find_or_create_for_vkontakte_oauth(vk_user, params[:access_token])
    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

end
