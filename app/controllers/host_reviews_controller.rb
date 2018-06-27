class HostReviewsController < ApplicationController
  # ホストからゲストへのレビュー
  def create
    # Step 1: Check if the reservation exist (listing_id, guest_id, host_id)

    # Step 2: Check if the current host already reviewed the guest in this reservation.

    @reservation = Reservation.where(
                    id: host_review_params[:reservation_id],
                    listing_id: host_review_params[:listing_id],
                    user_id: host_review_params[:guest_id]
                   ).first

    if !@reservation.nil?

      @has_reviewed = HostReview.where(
                        reservation_id: @reservation.id,
                        guest_id: host_review_params[:guest_id]
                      ).first

      if @has_reviewed.nil?
          # Allow to review
          @host_review = current_user.host_reviews.create(host_review_params)
          flash[:success] = "ゲストへのレビューが作成されました！"

          HostReviewMailer.send_email_to_host(@host_review).deliver



      else
          # Already reviewed
          flash[:success] = "既にレビュー済みです..."
      end

    else
      flash[:alert] = "まだレンタル購入履歴がありません..."
    end

    redirect_back(fallback_location: request.referer)
  end

  def destroy
    @host_review = Review.find(params[:id])
    @host_review.destroy

    redirect_back(fallback_location: request.referer, notice: "レビューを削除しました!")
  end

  private
    def host_review_params
      params.require(:host_review).permit(:comment, :star, :listing_id, :reservation_id, :guest_id)
    end
end
