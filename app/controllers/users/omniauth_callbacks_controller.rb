class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    # You need to implement the method below in your model
    auth = request.env["omniauth.auth"]
    facebook_user =  FbGraph::User.fetch(auth.uid, :access_token => auth.credentials.token)
    @user = User.find_or_create_for_facebook_oauth(facebook_user)
    
    @user.ensure_authentication_token!
    @user.save
    sign_in(@user)
    redirect_to feed_path
  end

  def vkontakte
    auth = request.env["omniauth.auth"]
    puts auth.to_yaml
    vk = VkontakteApi::Client.new(auth.credentials.token)
    vk_user = vk.users.get(uid: auth.uid, fields: User::VK_FIELDS).first
    #vk_user.merge!(email: params[:email])
    @user = User.find_or_create_for_vkontakte_oauth(vk_user, auth.credentials.token)
    @user.ensure_authentication_token!
    @user.vk_token_expiration = auth.credentials.expires_at
    @user.save
    sign_in(@user)
    redirect_to feed_path

  end

end
