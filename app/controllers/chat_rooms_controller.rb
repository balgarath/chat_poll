class ChatRoomsController < ApplicationController

  # GET /chat_rooms
  # GET /chat_rooms.xml
  def index
    @chat_rooms = ChatRoom.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @chat_rooms }
    end
  end

  # GET /chat_rooms/1
  # GET /chat_rooms/1.xml
  def show

    @chat_room = ChatRoom.find(params[:id])
  	session[@chat_room.id] ||= {}
		@message = ChatText.new
		
		if params[:user]
			@chat_user ||= ChatUser.create(:name => params[:user], :chat_room => @chat_room) 
			session[@chat_room.id][:user] = @chat_user.id
			ChatText.create(:chat_room_id => @chat_room.id, :user => 'System', :body => @chat_user.name + " has entered the room.")
		end
		
		@messages = ChatText.find_all_by_chat_room_id(@chat_room.id)[-20..-1] || []
		
		if @messages.empty?
      session[@chat_room.id][:message_id] = -1
		else
			session[@chat_room.id][:message_id] = @messages.map(&:id).max
		end	
	
    respond_to do |format|
      format.html  { render :layout => 'chat'}# show.html.erb
      format.xml  { render :xml => @chat_room }
    end
  end

  # GET /chat_rooms/new
  # GET /chat_rooms/new.xml
  def new
    @chat_room = ChatRoom.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @chat_room }
    end
  end

  # GET /chat_rooms/1/edit
  def edit
    @chat_room = ChatRoom.find(params[:id])
  end

  # POST /chat_rooms
  # POST /chat_rooms.xml
  def create
    @chat_room = ChatRoom.new(params[:chat_room])

    respond_to do |format|
      if @chat_room.save
        flash[:notice] = 'ChatRoom was successfully created.'
        format.html { redirect_to(@chat_room) }
        format.xml  { render :xml => @chat_room, :status => :created, :location => @chat_room }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @chat_room.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /chat_rooms/1
  # PUT /chat_rooms/1.xml
  def update
    @chat_room = ChatRoom.find(params[:id])

    respond_to do |format|
      if @chat_room.update_attributes(params[:chat_room])
        flash[:notice] = 'ChatRoom was successfully updated.'
        format.html { redirect_to(@chat_room) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @chat_room.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /chat_rooms/1
  # DELETE /chat_rooms/1.xml
  def destroy
    @chat_room = ChatRoom.find(params[:id])
    @chat_room.destroy

    respond_to do |format|
      format.html { redirect_to(chat_rooms_url) }
      format.xml  { head :ok }
    end
  end
end
