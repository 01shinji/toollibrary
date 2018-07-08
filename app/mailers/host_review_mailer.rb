class HostReviewMailer < ApplicationMailer
  # ホストからゲストへのレビュー
  def send_email_to_host(host_review)

    @host_review = host_review

    @guest = User.find_by(id: @host_review.guest_id)


    mail(to: @guest.email, from: "s-kawabata@digisurf.co.jp", subject: "[ホストからレビューが届きました]サーフ文庫🌊🏄")
  end



end
