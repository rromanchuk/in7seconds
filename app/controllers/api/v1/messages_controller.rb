module Api
  module V1
    
    class MessagesController < Api::BaseController
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
        #broadcast("/messages", {test: "test"})

        if @message.from_user == current_user
          logger.error "is from self"
        else
          logger.error "is not from self"
        end

        render 'api/v1/messages/show'
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
    
  end
end