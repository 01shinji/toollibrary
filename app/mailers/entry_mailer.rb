class EntryMailer < ActionMailer::Base
  ##### 送信元アドレス
  default from: "s-kawabata@digisurf.co.jp"

  def received_email(entry)

    @entry = entry
    mail(to: @entry.email, :subject => "[応募]サーフ文庫🌊🏄")
  end


end
