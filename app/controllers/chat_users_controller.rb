class ChatUsersController < ApplicationController

	before_filter :load_chat_room

	def index
		@chat_users = ChatUser.refresh(@chat_room.id)
		logger.info "Chat Room:\n" + @chat_room.id.to_s
    respond_to do |format|
      format.json { render :json => @chat_users}
      format.xml { render :xml => @chat_users}
    end		
	end

	private
	
	def load_chat_room
		@chat_room = ChatRoom.find(params[:chat_room_id])	
	end
	
end
