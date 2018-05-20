class ListingsController < ApplicationController
  before_action :set_listing, except: [:index, :new, :create]
  before_action :authenticate_user!, except: [:show]

  before_action :is_authorised, only: [ :information1, :information2, :photo_upload, :update]

  def index
    @listings = current_user.listings

  end

  def new
    if !current_user.phone_verified
     flash[:alert] = "電話番号の認証が必要です"
     return redirect_to edit_user_registration_path
    elsif !current_user.license_file_name
     flash[:alert] = "身分証明書の登録が必要です"
     return redirect_to edit_user_registration_path

    elsif
     !current_user.nickname ||
     !current_user.image_file_name ||
     !current_user.address_zipcode ||
     !current_user.address_prefecture_name

     return redirect_to edit_user_registration_path, alert: "プロフィールの登録をお願いします"

    else
     @listing = current_user.listings.build
    end

  end

  def create

    @listing = current_user.listings.build(listing_params)

    @photos = @listing.photos
     if @listing.save
      redirect_to information1_listing_path(@listing), notice: "商品の仮登録が成功しました!最後まで入力をお願いします〜"
     else
      flash[:alert] = "出品がうまくいきませんでした..."
      render :new
     end

  end

  def show
    @photos = @listing.photos
    @guest_reviews = @listing.guest_reviews
  end

  def information1
  end

  def information2
    @listing = Listing.find(params[:id])
    @user = User.find(@listing.user_id)
  end

  def photo_upload
    @photos = @listing.photos
  end


  def update
    new_params = listing_params
    new_params = listing_params.merge(active: true) if is_ready_listing

    if @listing.update(new_params)
      flash[:notice] = "商品情報を編集しました"
    elsif
       @listing.update(new_params)
      flash[:notice] = "商品情報を編集しました"
    else
      flash[:alert] = "商品情報の編集がうまくいきませんでした"
    end
    redirect_back(fallback_location: request.referer)

  end

  # 予約フォーム
  def preload
    today = Date.today
    reservations = @listing.reservations.where("(start_date >= ? OR end_date >= ?) AND status = ?", today, today, 1)

    render json: reservations
  end

  def preview
    start_date = Date.parse(params[:start_date])
    end_date = Date.parse(params[:end_date])

    output = {
      conflict: is_conflict(start_date, end_date, @listing)
    }

    render json: output
  end

  private
  def is_conflict(start_date, end_date, listing)
    check = listing.reservations.where("(? < start_date AND end_date < ?) AND status = ?", start_date, end_date, 1)
    check.size > 0? true : false
  end

  def set_listing
    @listing = Listing.find(params[:id])
  end

  def is_authorised
    redirect_to root_path, alert: "このページを編集する権限がありません" unless current_user.id == @listing.user_id
  end



  def is_ready_listing
    !@listing.active && !@listing.price_day.blank? && !@listing.photos.blank?
  end

  def listing_params
    params.require(:listing).permit(:listing_title, :listing_type, :category1, :category2,  :price, :price_per,  :price_hour, :price_day, :price_month, :description, :location, :is_shower, :is_bicycle, :is_wetsuit, :purchase_price, :purchase_time, :active, :instant)
  end
end
