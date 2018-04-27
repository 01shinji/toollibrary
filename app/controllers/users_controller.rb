class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:show]

  def show
    @user = User.find(params[:id])
    @listings = @user.listings

    # ゲストから自分(ホスト)へのレビュー一覧(※自分がホストの場合)
    @guest_reviews = Review.where(type: "GuestReview", host_id: @user.id)

    # ホストから自分(ゲスト)へのレビュー一覧(※自分がゲストの場合)
    @host_reviews = Review.where(type: "HostReview", guest_id: @user.id)
  end

  def update_phone_number
    current_user.update_attributes(user_params)
    current_user.generate_pin
    current_user.send_pin

    redirect_to edit_user_registration_path, notice: "電話番号を変更しました!"
  rescue Exception => e
    redirect_to edit_user_registration_path, alert: "#{e.message}"
  end

  def verify_phone_number
    current_user.verify_pin(params[:user][:pin])

    if current_user.phone_verified
      flash[:notice] = "電話番号の認証に成功しました!"
    else
      flash[:alert] = "電話番号の認証に失敗しました..."
    end

    redirect_to edit_user_registration_path

  rescue Exception => e
    redirect_to edit_user_registration_path, alert: "#{e.message}"
  end


  def payment
  end

  def payout
    if !current_user.merchant_id.blank?
     account = Stripe::Account.retrieve(current_user.merchant_id)
     @login_link = account.login_links.create()
    end
  end

  def add_card
   if current_user.stripe_id.blank?
     customer = Stripe::Customer.create(
       email: current_user.email
     )
     current_user.stripe_id = customer.id
     current_user.save

     # Add Credit Card to Stripe
     customer.sources.create(source: params[:stripeToken])
   else
     customer = Stripe::Customer.retrieve(current_user.stripe_id)
     customer.source = params[:stripeToken]
     customer.save
   end

   flash[:notice] = "カード情報が登録されました!"
   redirect_to payment_method_path
  rescue Stripe::CardError => e
   flash[:alert] = e.message
   redirect_to payment_method_path
  end

  private

    def user_params
      params.require(:user).permit(:phone_number, :pin)
    end
end
