class ChatUser < ActiveRecord::Base
  belongs_to :chat_room

  def self.refresh(chat_room_id)
    find(:all, :order => 'chat_users.name asc', :conditions => ['chat_users.updated_at > ? and chat_room_id = ?', 20.seconds.ago, chat_room_id])
  end	
end
