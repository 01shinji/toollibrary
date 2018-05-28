class EntryMailer < ActionMailer::Base

  # 応募者が受け取るメール
  def sent_email(entry)

    @entry = entry

    mail(to: @entry.email, from: "s-kawabata@digisurf.co.jp", subject: "[応募•問合せ]サーフ文庫🌊🏄")
  end

  # サーフ文庫が受け取るメール
  def received_email(entry)

    @entry = entry

    mail(to: "s-kawabata@digisurf.co.jp", from: @entry.email, subject: "応募•問合せがありました")
  end


end
