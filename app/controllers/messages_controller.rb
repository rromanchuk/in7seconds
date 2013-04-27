# encoding: utf-8
class MessagesController < ApplicationController
  before_filter :authenticate_user!
  respond_to :json

  def create
    hookup = User.find(params[:user_id])
    
    first_message = Message.first_message(current_user, hookup)
    logger.error "first message in create action: " + first_message.inspect
    if first_message
      @message = first_message.replies.build(:to_user => hookup, :from_user => current_user, :message => params[:message][:message])
      @message.save
    else
      first_message = Message.new(:to_user => hookup, :from_user => current_user, :message => params[:message][:message])
      first_message.save
      @message = first_message
    end
    
    @message.reload
    broadcast("message", {test: "test"})

    if params[:lite_version]
      @hookup = hookup
      render 'messages/show_lite'
    else
      render :show
    end
  end

  def index
    hookup = User.find(params[:user_id])
    @messages = Message.thread(current_user, hookup)
  end

  def thread
    @hookup = User.find(params[:user_id])
    @messages = Message.thread(current_user, @hookup)
    if @messages.blank?
      render json: ''
    else
      respond_with @messages
    end
  end

end
