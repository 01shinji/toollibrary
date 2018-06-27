class HostReviewMailer < ApplicationMailer
  # ホストからゲストへのレビュー
  def send_email_to_host(host_review)

    @host_review = host_review


    mail(to: @host_review.host.email, from: "s-kawabata@digisurf.co.jp", subject: "[ホストからレビューが届きました]サーフ文庫🌊🏄")
  end



end
