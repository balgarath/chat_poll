ActionController::Routing::Routes.draw do |map|
  map.resources :chat_rooms, :has_many => :chat_texts
  map.resources :chat_rooms, :has_many => :chat_users
end
