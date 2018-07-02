class ApplyMailer < ActionMailer::Base

  # 応募者が受け取るメール
  def sent_email(apply)

    @apply = apply

    mail(to: @apply.email, from: "s-kawabata@digisurf.co.jp", subject: "[応募•問合せ]サーフ文庫🌊🏄")
  end

  # サーフ文庫が受け取るメール
  def received_email(apply)

    @apply = apply

    mail(to: "s-kawabata@digisurf.co.jp", from: @apply.email, subject: "応募•問合せがありました")
  end


end
