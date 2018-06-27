class GuestReviewMailer < ApplicationMailer
  # ゲストからホストへのレビュー

  def send_email_to_guest(guest_review)

    @guest_review = guest_review


    mail(to: @guest_review.guest.email, from: "s-kawabata@digisurf.co.jp", subject: "[ゲストからレビューが届きました]サーフ文庫🌊🏄")
  end


end
