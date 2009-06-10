class ChatText < ActiveRecord::Base
  belongs_to :chat_room


  
  def self.refresh(id, chat_room_id)
    find(:all, :order => 'chat_texts.id desc', :conditions => ['chat_texts.id > ? and chat_room_id = ?', id, chat_room_id])
  end

end
