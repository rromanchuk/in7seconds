# encoding: utf-8
class MessagesController < ApplicationController
  before_filter :authenticate_user!
  respond_to :json

  def create
    hookup = User.find(params[:user_id])
    first_message = Message.first_message(current_user, hookup)
    if first_message
      @message = first_message.replies.build(:to_user => @hookup, :from_user => current_user, :body => params[:message][:message])
    else
      @message = Message.new(:to_user => hookup, :from_user => current_user, :message => params[:message][:message])
    end
    Notification.send_message(hookup, @message.message)
    @message.save
    render :show
  end

  def index
    hookup = User.find(params[:user_id])
    first_message = Message.first_message(current_user, hookup)
    @messages
  end


end
