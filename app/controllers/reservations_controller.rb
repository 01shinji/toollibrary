
class ReservationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reservation, only: [:approve, :decline]


  def create
    listing = Listing.find(params[:listing_id])

    start_date = Date.parse(reservation_params[:start_date])
    end_date = Date.parse(reservation_params[:end_date])
    @days = (end_date - start_date).to_i + 1

    if current_user == listing.user
      flash[:alert] = "自分の商品を予約することはできません"

    elsif !current_user.stripe_id
      flash[:alert] = "クレジットカードを登録してください"
      return redirect_to payment_method_path

    elsif !current_user.phone_verified
      flash[:alert] = "電話番号の認証が必要です"
      return redirect_to certification_path
    elsif !current_user.license_file_name
      flash[:alert] = "身分証明書の登録が必要です"
      return redirect_to certification_path

    elsif
     current_user.fullname.nil? ||
     current_user.nickname.nil? ||

     current_user.address_zipcode.nil? ||
     current_user.address_prefecture_name.nil?

     return redirect_to edit_user_registration_path, alert: "プロフィールの登録をお願いします"

    else

      @reservation = current_user.reservations.build(reservation_params)
      @reservation.listing = listing
      @reservation.price = listing.price_day
      @reservation.total = @days * (listing.price_day  +  listing.price_day * 0.10 )


      # @reservation.save

      if @reservation.Waiting!
        if listing.Request?
          flash[:notice] = "ホストにリクエストが送られました!"

          ReservationMailer.request_to_guest(@reservation).deliver
          ReservationMailer.request_to_host(@reservation).deliver


        else
          charge(listing, @reservation)
        end
      else
        flash[:alert] = "予約ができませんでした"
      end

    end
    redirect_to("/listings/#{@reservation.listing.id}/reservations/#{@reservation.id}")

  end

  def show
    @reservation = Reservation.find(params[:id])

    @days = @reservation.total / (@reservation.listing.price_day  +  @reservation.listing.price_day * 0.10 ).to_i

    # ホストへの支払い
    @host_total = @days * (@reservation.listing.price_day  -  @reservation.listing.price_day * 0.10 ).to_i

    @date = Date.today


    if current_user == @reservation.user || current_user == @reservation.listing.user

    else
      redirect_to dashboard_path, alert: "このページを見る権限がありません"
    end

  end

  # ゲストとして他のホストのリスティングを予約
  def my_reservations
    @my_reservations = current_user.reservations.order(start_date: :desc)

    @date = Date.today


  end

  # ホストである自分に対してのゲストからの予約
  def guest_reservations
    @listings = current_user.listings

    @date = Date.today

  end

  def approve
    @date = Date.today

    charge(@reservation.listing, @reservation)
    redirect_to("/listings/#{@reservation.listing.id}/reservations/#{@reservation.id}")
    flash[:notice] = "ゲストからのリクエストを承認しました!"

    ReservationMailer.approve_to_guest(@reservation).deliver
    ReservationMailer.approve_to_host(@reservation).deliver

    # 前日メール
    if @reservation.start_date.day == @date.day + 1
      ReservationMailer.previous_to_guest(@reservation).deliver
      ReservationMailer.previous_to_host(@reservation).deliver
    end

    # 後日メール
    if @reservation.end_date.day == @date.day - 1
      ReservationMailer.following_to_guest(@reservation).deliver
      ReservationMailer.following_to_host(@reservation).deliver

    end

  end

  def decline
    @reservation.Declined!
    redirect_to("/listings/#{@reservation.listing.id}/reservations/#{@reservation.id}")
    flash[:notice] = "ゲストからのリクエストをお断りしました"

    ReservationMailer.decline_to_guest(@reservation).deliver
    ReservationMailer.decline_to_host(@reservation).deliver

  end


  private

  def charge(listing, reservation)

    if !reservation.user.stripe_id.blank?
     customer = Stripe::Customer.retrieve(reservation.user.stripe_id)
     charge = Stripe::Charge.create(
      customer: customer.id,
      amount: reservation.total,
      description: listing.listing_title,
      currency: "jpy",

      # destination: {
            # amount: reservation.total * 85,
            # account: listing.user.merchant_id
          # }

    )

     if charge
      reservation.Approved!
      ReservationMailer.send_email_to_guest(reservation.user, listing).deliver_later
      flash[:notice] = "予約が成立しました!"

     else
      reservation.Declined!
      flash[:alert] = "予約が成立しませんでした"
     end

    end

  rescue Stripe::CardError => e
   reservation.Declined!
   flash[:alert] = e.message

  end


  def set_reservation
    @reservation = Reservation.find(params[:id])
  end

  def reservation_params
    params.require(:reservation).permit(:start_date, :end_date)
  end
end
