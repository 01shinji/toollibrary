class GuestReviewMailer < ApplicationMailer
  # ゲストからホストへのレビュー

  def send_email_to_guest(guest_review)

    @guest_review = guest_review

    @host = User.find_by(id: @guest_review.host_id)


    mail(to: @host.email, from: "s-kawabata@digisurf.co.jp", subject: "[ゲストからレビューが届きました]サーフ文庫🌊🏄")
  end


end
