class InquiryMailer < ActionMailer::Base
  ##### 送信元アドレス
  default from: "s-kawabata@digisurf.co.jp"

  def received_email(inquiry)

    @inquiry = inquiry
    mail(to: @inquiry.email, :subject => "[お問合わせ]サーフ文庫🌊🏄")
  end


end
