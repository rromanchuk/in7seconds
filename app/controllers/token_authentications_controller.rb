# encoding: utf-8
# DEPRECATED
class TokenAuthenticationsController < ApplicationController 
  skip_before_filter :verify_authenticity_token
  respond_to :json

  # DEPRECATED SOON TO BE DELETED
  def create
    if params[:platform] == "facebook"
      facebook_user = FbGraph::User.fetch(params[:user_id], :access_token => params[:access_token])
      @user = User.find_or_create_for_facebook_oauth(facebook_user)
    elsif params[:platform] == "vkontakte"
      @vk = VkontakteApi::Client.new(params[:access_token])
      vk_user = @vk.users.get(uid: params[:user_id], fields: User::VK_FIELDS).first
      if params[:email].include?("@")
        vk_user.merge!(email: params[:email])
      end
      
      @user = User.find_or_create_for_vkontakte_oauth(vk_user, params[:access_token])
    end
    
    @user.ensure_authentication_token!
    @user.save
    sign_in(@user)
    render "users/authenticated_user"
  end

  # DEPRECATED SOON TO BE DELETED
  def destroy
    @user = User.criteria.id(params[:id]).first
    @user.authentication_token = nil
    @user.save
    redirect_to edit_user_registration_path(@user)
  end

end