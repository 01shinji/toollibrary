class Message < ApplicationRecord
  belongs_to :user
  belongs_to :conversation

  validates_presence_of :context, :conversation_id, :user_id
  after_create_commit :create_notification

  def message_time
    self.created_at.strftime("%m月%d日 %H:%M")
  end

  private

  def create_notification
    if self.conversation.sender_id == self.user_id
      sender = User.find(self.conversation.sender_id)

      link = "<a href = 'https://www.toollibrary.jp/conversations'>#{sender.fullname}さんからの新しいメッセージ</a>"

      Notification.create(content: "#{link}", user_id: self.conversation.recipient_id)

      ConversationMailer.send_email_to_recipient(self.conversation).deliver

    else
      sender = User.find(self.conversation.recipient_id)

      link = "<a href = 'https://www.toollibrary.jp/conversations'>#{sender.fullname}さんからの新しいメッセージ</a>"

      Notification.create(content: "#{link}", user_id: self.conversation.sender_id)

      ConversationMailer.send_email_to_sender(self.conversation).deliver
    end




  end

end
