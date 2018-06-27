class ConversationMailer < ApplicationMailer


  def send_email_to_sender(conversation)
    @conversation = conversation


    mail(to: @conversation.sender.email, from: "s-kawabata@digisurf.co.jp", subject: "[メッセージ]サーフ文庫🌊🏄")
  end

  def send_email_to_recipient(conversation)
    @conversation = conversation


    mail(to: @conversation.recipient.email, from: "s-kawabata@digisurf.co.jp", subject: "[メッセージ]サーフ文庫🌊🏄")
  end

end
