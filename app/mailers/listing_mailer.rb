class ListingMailer < ApplicationMailer

  def send_email_to_host(listing)

    @listing = listing


    mail(to: @listing.user.email, from: "s-kawabata@digisurf.co.jp", :subject => "[出品しました]サーフ文庫🌊🏄")

  end

end
