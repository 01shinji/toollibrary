class ReservationMailer < ApplicationMailer

  def send_email_to_guest(guest, listing)
    @recipient = guest
    @listing = listing

    @reservation = reservation

    mail(to: @recipient.email, subject: "[予約完了]サーフ文庫🌊🏄")
  end

  # ゲストへの予約リクエスト確認メール
  def request_to_guest(reservation)

    @reservation = reservation


    mail(to: @reservation.user.email, from: "s-kawabata@digisurf.co.jp", :subject => "[リクエスト確認]サーフ文庫🌊🏄")

  end

  # ホストへの予約リクエスト確認メール
  def request_to_host(reservation)

    @reservation = reservation


    mail(to: @reservation.listing.user.email, from: "s-kawabata@digisurf.co.jp", :subject => "[リクエストがありました]サーフ文庫🌊🏄")

  end

  # 運営者への予約リクエスト確認メール
  def request_to_me(reservation)

    @reservation = reservation


    mail(to: "satoyama.shinji@gmail.com", from: "s-kawabata@digisurf.co.jp", :subject => "[注]予約リクエスト")

  end

  # ゲストへの予約確定メール
  def approve_to_guest(reservation)

    @reservation = reservation


    mail(to: @reservation.user.email, from: "s-kawabata@digisurf.co.jp", :subject => "[予約確定]サーフ文庫🌊🏄")

  end

  # ホストへの予約確定メール
  def approve_to_host(reservation)

    @reservation = reservation


    mail(to: @reservation.listing.user.email, from: "s-kawabata@digisurf.co.jp", :subject => "[予約確定]サーフ文庫🌊🏄")

  end

  # ゲストへの前日メール
  def previous_to_guest(reservation)
    @reservation = reservation


    mail(to: @reservation.user.email, from: "s-kawabata@digisurf.co.jp", :subject => "[前日になりました]サーフ文庫🌊🏄")
  end

  # ホストへの前日メール
  def previous_to_host(reservation)
    @reservation = reservation


    mail(to: @reservation.listing.user.email, from: "s-kawabata@digisurf.co.jp", :subject => "[前日になりました]サーフ文庫🌊🏄")
  end

  # ゲストへの後日メール
  def following_to_guest(reservation)
    @reservation = reservation


    mail(to: @reservation.user.email, from: "s-kawabata@digisurf.co.jp", :subject => "[楽しい時間を過ごせましたか?]サーフ文庫🌊🏄")
  end

  # ホストへの後日メール
  def following_to_host(reservation)
    @reservation = reservation


    mail(to: @reservation.listing.user.email, from: "s-kawabata@digisurf.co.jp", :subject => "[楽しい時間を過ごせましたか?]サーフ文庫🌊🏄")
  end

  # ゲストへの予約リクエストお断りメール
  def decline_to_guest(reservation)

    @reservation = reservation

    attachments.inline["entry-1-min.jpg"] = File.read("app/assets/images/entry-1-min.jpg")

    mail(to: @reservation.user.email, from: "s-kawabata@digisurf.co.jp", :subject => "[リクエストお断り]サーフ文庫🌊🏄")

  end

  # ホストへの予約リクエストお断り確認メール
  def decline_to_host(reservation)

    @reservation = reservation

    attachments.inline["entry-1-min.jpg"] = File.read("app/assets/images/entry-1-min.jpg")

    mail(to: @reservation.listing.user.email, from: "s-kawabata@digisurf.co.jp", :subject => "[リクエストお断り]サーフ文庫🌊🏄")

  end



end
