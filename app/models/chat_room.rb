class ChatRoom < ActiveRecord::Base
	has_many :chat_users

end
