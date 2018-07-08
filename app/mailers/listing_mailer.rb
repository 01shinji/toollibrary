class ListingMailer < ApplicationMailer

  # 商品登録後にホストにメール
  def send_email_to_host(listing)

    @listing = listing


    mail(to: @listing.user.email, from: "s-kawabata@digisurf.co.jp", :subject => "[登録しました]サーフ文庫🌊🏄")

  end

end
