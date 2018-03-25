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

end
