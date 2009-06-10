class ChatTextsController < ApplicationController

	before_filter :load_chat_room
	
  def index
  	session[@chat_room.id][:message_id] ||= -1
  	
  	@chat_user = ChatUser.find(session[@chat_room.id][:user])
      @chat_user.updated_at = Time.now
      @chat_user.save
      
    @messages = ChatText.refresh(session[@chat_room.id][:message_id], @chat_room.id)
    
    unless @messages.empty?
      session[@chat_room.id][:message_id] = @messages.map(&:id).max
      logger.info @messages.length.to_s + " new messages to refresh."
	    respond_to do |format|
	      format.html # index.html.erb
	      format.json { render :json => @messages}
	      format.xml { render :xml => @messages}
	      #format.xml  { render :xml => messages = [@messages.collect{|m| {:body => m.body, :user => m.user}}] }
	    end

    else
    	logger.info "No messages to update."
      render :nothing => true
    end
  end
  	
	
	def create
    @message = ChatText.new(params[:chat_text])
		@message.chat_room = @chat_room
    respond_to do |format|
      if @message.save
      	format.js { render :json => @message }
        format.html { redirect_to(@chat_room) }
        format.xml  { render :xml => @message, :status => :created, :location => @message }
        format.json { render :json => @message }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @chat_room.errors, :status => :unprocessable_entity }
        format.json { render :json => @message.errors }
      end
    end		
	end
	
	private

	def load_chat_room
		@chat_room = ChatRoom.find(params[:chat_room_id])	
	end

end
