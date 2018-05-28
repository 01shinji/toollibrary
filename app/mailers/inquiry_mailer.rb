class InquiryMailer < ActionMailer::Base

  # 問合せ者が受け取るメール
  def sent_email(inquiry)

    @inquiry = inquiry

    mail(to: @inquiry.email, from: "s-kawabata@digisurf.co.jp", :subject => "[お問合わせ]サーフ文庫🌊🏄")
  end

  # サーフ文庫が受け取るメール
  def received_email(inquiry)

    @inquiry = inquiry
    mail(to: "s-kawabata@digisurf.co.jp", from: @inquiry.email, :subject => "問合せがありました")
  end


end
