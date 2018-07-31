class PagesController < ApplicationController

  def index
    @q = Listing.ransack(params[:q])

    @listings = Listing.where(active: true)
    @listings = @listings.order(created_at: :desc)

    @listings = @q.result.includes( :photos, :user).order(created_at: :desc)
  end

  def refer
    @q = Listing.search(refer_params)

    @listings = Listing.where(active: true)
    @listings = @listings.order(created_at: :desc)

    @listings = @q.result.includes( :photos, :user).order(created_at: :desc)
  end



  def home
    @listings = Listing.where(active: true).includes( :photos, :user)
    @listings = @listings.order(created_at: :desc)

    @users = User.includes(:listings).where.not(listings: {id: nil})
    @users = @users.order(created_at: :desc)



  end

  def search
    # STEP 1
    if params[:search].present? && params[:search].strip != ""

      session[:address] = params[:search]
      @address = session[:address]

      if params["lat"].present? & params["lng"].present?
        @latitude = params["lat"]
        @longitude = params["lng"]

        geolocation = [@latitude,@longitude]
      else
        geolocation = Geocoder.coordinates(params[:search])
        @latitude = geolocation[0]
        @longitude = geolocation[1]
      end

      @listings_address = Listing.where(active: true).near(geolocation, 5, order: 'distance')

      # 検索欄が空欄の場合
    else

      @listings_address = Listing.where(active: true).all
      @latitude = @listings_address.to_a[0].latitude
      @longitude = @listings_address.to_a[0].longitude
    end


    # Ransack q のチェックボックス一覧
    if params[:q].present?

     # category1
     if params[:q][:category1_eq_any].present?

       session[:category1_eq_any] = params[:q][:category1_eq_any]

       session[:surfboard] = session[:category1_eq_any].include?("サーフボード")
       session[:supboard] = session[:category1_eq_any].include?("SUPボード")
       session[:others] = session[:category1_eq_any].include?("その他")




     else
       session[:category1_eq_any] = ""


       session[:surfboard] = false
       session[:supboard] = false
       session[:others] = false


     end


     # listing_type
     if params[:q][:listing_type_eq_any].present?
       session[:listing_type_eq_any] = params[:q][:listing_type_eq_any]

       session[:rental] = session[:listing_type_eq].include?("レンタル")
       session[:buying_and_selling] = session[:listing_type_eq_any].include?("販売")
       session[:coaching] = session[:listing_type_eq_any].include?("コーチング")
     else
       session[:listing_type_eq_any] = ""

       session[:rental] = false
       session[:buying_and_selling] = false
       session[:coaching] = false
     end

     # price_day
     if params[:q][:price_day_gteq].present?
       session[:price_day_gteq] = params[:q][:price_day_gteq]
     else
       session[:price_day_gteq] = nil
     end
     if params[:q][:price_day_lteq].present?
       session[:price_day_lteq] = params[:q][:price_day_lteq]
     else
       session[:price_day_lteq] = nil
     end


    end

    # Q条件をまとめたものをセッションQに入れる
    session[:q] = {

     "category1_eq_any" => session[:category1_eq_any],



     "listing_type_eq_any" => session[:listing_type_eq_any],

     "price_day_gteq" => session[:price_day_gteq],

     "price_day_lteq" => session[:price_day_lteq]

    }


    # STEP 3
    @search = @listings_address.ransack(session[:q])
    @listings = @search.result(distinct: true).includes( :photos, :user)



    @arrListings = @listings.to_a

    # STEP 4
    if (params[:start_date] && params[:end_date] && !params[:start_date].empty? &&  !params[:end_date].empty?)

      session[:start_date] = params[:start_date]
      session[:end_date] = params[:end_date]


      start_date = Date.parse(session[:start_date])
      end_date = Date.parse(session[:end_date])

      @listings.each do |listing|

        not_available = listing.reservations.where(
          "((? <= start_date AND start_date <= ?)
          OR (? <= end_date AND end_date <= ?)
          OR (start_date < ? AND ? < end_date))
          AND status = ?",
          start_date, end_date,
          start_date, end_date,
          start_date, end_date,
          1
        ).limit(1)

        if not_available.length > 0
          @arrListings.delete(listing)
        end

      end

    end
  end

  def ajaxsearch
   # まずajaxで送られてきた緯度経度をセッションに入れる
   if !params[:geolocation].blank?
     geolocation = params[:geolocation]
   end

   # ajaxで送られてきた場所の住所をセッションに入れる
   if !params[:location].blank?
     session[:address] = params[:location]
   end

   @listings = Listing.where(active: true).near(geolocation, 5, order: 'distance')

   #リスティングデータを配列にしてまとめる
   @arrListings = @listings.to_a

   # start_date end_dateの間に予約がないことを確認.あれば削除
   if ( !session[:start_date].blank? && !session[:end_date].blank? )

     start_date = Date.parse(session[:start_date])
     end_date = Date.parse(session[:end_date])

     @listings.each do |listing|

       not_available = listing.reservations.where(
         "((? <= start_date AND start_date <= ?)
         OR (? <= end_date AND end_date <= ?)
         OR (start_date < ? AND ? < end_date))
         AND status = ?",
         start_date, end_date,
         start_date, end_date,
         start_date, end_date,
         1
       ).limit(1)

       if not_available.length > 0
         @arrListings.delete(listing)
       end

     end

   end

   respond_to :js

  end

  private
  def refer_params
    params.require(:q).permit(:category1_eq, :category2_eq)
  end


end
