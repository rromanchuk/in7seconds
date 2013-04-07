# encoding: utf-8
class UsersController < ApplicationController
  before_filter :authenticate_user!, :except => [:system_settings, :unsubscribe]
  respond_to :json, :html
  
   def flirt
    hookup = User.find(params[:relationship][:hookup_id])
    if current_user.is_requested?(hookup)
      User.fuck(current_user, hookup)
      @user = hookup
      render 'users/hookup_user'
      return
    else
      current_user.flirt(hookup)
    end
    render json: ''
  end

  def reject
    @hookup = User.find(params[:relationship][:hookup_id])
    User.reject(current_user, @hookup)
    render json: ''
  end

  def home
    # @feed_items = current_user.feed
    # respond_with @feed_items
  end

  def show
    @user = User.find(params[:id])
    render :hookup_user
  end

  def me
    @user = current_user
    render :show
  end

  def following_followers
    @user = current_user
  end

  def settings
    @user = current_user
    respond_with @user
  end

  def system_settings

  end

  def update_user
    @user = current_user
    @user.update_attributes(params[:user])
    render :show
  end

  def update_settings
    @user = current_user
    @user.update_attributes(params[:user])
    render :show
  end

  def unsubscribe
    if user = User.read_access_token(params[:signature])
      user.update_attribute :email_opt_in, false
      render text: "Подписка отменена"
    else
      render text: "Неверная ссылка"
    end
  end

  def feed

  end

end