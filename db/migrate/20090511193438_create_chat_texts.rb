class CreateChatTexts < ActiveRecord::Migration
  def self.up
    create_table :chat_texts do |t|
      t.string :user
      t.string :body
      t.references :chat_room

      t.timestamps
    end
  end

  def self.down
    drop_table :chat_texts
  end
end
