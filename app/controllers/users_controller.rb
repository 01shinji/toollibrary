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

  def certification

  end

  def update_phone_number
    current_user.update_attributes(user_params)
    current_user.generate_pin
    current_user.send_pin

    redirect_to edit_user_registration_path, notice: "認証コードを送りました、電話番号の認証をお願いします"
  rescue Exception => e
    redirect_to certification_path, alert: "#{e.message}"
  end

  def verify_phone_number
    current_user.verify_pin(params[:user][:pin])

    if current_user.phone_verified
      flash[:notice] = "電話番号の認証に成功しました!"
    else
      flash[:alert] = "電話番号の認証に失敗しました"
    end

    redirect_to certification_path

  rescue Exception => e
    redirect_to certification_path, alert: "#{e.message}"
  end

  def update_license
    current_user.update_attributes(user_params)
    redirect_to certification_path, notice: "身分証を登録しました!"
  end

  def payment
  end

  def payout

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


  def update_bank_account
    current_user.update_attributes(user_params)
    redirect_to payout_method_path, notice: "振込先口座を変更しました!"
  end



  private

    def user_params
      params.require(:user).permit(:phone_number, :pin, :bank_name, :account_type, :branch_code, :account_number, :account_name, :license)
    end
end
