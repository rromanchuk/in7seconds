# encoding: utf-8
class RelationshipsController < ApplicationController
  before_filter :authenticate_user!
  respond_to :json

  def flirt
    hookup = User.find(params[:relationship][:hookup_id])
    if current_user.is_requested?(hookup)
      User.fuck(current_user, hookup)
      Notification.fuck(current_user, hookup)
    else
      User.flirt(current_user, hookup)
    end
    render json: ''
  end

  def reject
    @hookup = User.find(params[:relationship][:hookup_id])
    User.reject(current_user, @hookup)
    render json: ''
  end

  def create
    @user = User.find(params[:relationship][:followed_id])
    current_user.follow!(@user)

    Notification.did_friend_user(current_user, @user)

    render "users/show"
  end

  def destroy
    @user = User.find(params[:id])
    current_user.unfollow!(@user)
    render "users/show"
  end

end
