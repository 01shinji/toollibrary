class PagesController < ApplicationController
  def home
    @listings = Listing.where(active: true).limit(4)
  end

  def search
    # STEP 1
    if params[:search].present? && params[:search].strip != ""

      session[:address] = params[:search]

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


    # STEP 3
    @search = @listings_address.ransack(params[:q])
    @listings = @search.result(distinct: true)
    if !@listings.present?
       flash[:alert] = "こちらの地域にはまだ出品がありません..."
    end


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


end
