module Api
  module V1
    
    class RelationshipsController < Api::BaseController
      before_filter :authenticate_user!
      respond_to :json  
    end
  end
end