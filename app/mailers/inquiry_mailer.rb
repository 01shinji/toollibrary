class InquiryMailer < ActionMailer::Base
  ##### 送信元アドレス
  default from: "s-kawabata@digisurf.co.jp"
  ##### 送信先アドレス
  default to: "example@example.com"

  def received_email(inquiry)

    @inquiry = inquiry
    mail(:subject => "[お問合わせ]サーフ文庫🌊🏄")
  end


end
