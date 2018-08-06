class Reservation < ApplicationRecord
  enum status: {Waiting: 0, Approved: 1, Declined: 2}

  after_create_commit :host_create_notification
  after_create_commit :guest_create_notification
  after_update_commit :host_update_notification
  after_update_commit :guest_update_notification


  belongs_to :user
  belongs_to :listing

  scope :current_week_revenue, -> (user) {
    joins(:listing)
    .where("listings.user_id = ? AND reservations.updated_at >= ? AND reservations.status = ?", user.id, 1.week.ago, 1)
    .order(updated_at: :asc)
  }





  private
  # ホストへの通知
  def host_create_notification
    type = self.listing.Instant? ? "新しい予約" : "新しいリクエスト"

    guest = User.find(self.user_id)

    link = "<a href = 'https://www.toollibrary.jp/guest_reservations'>#{guest.fullname}さんからの#{type}</a>"

    Notification.create(content: "#{link}", user_id: self.listing.user_id)



  end

  def host_update_notification
    type = self.listing.Instant? ? "新しい予約" : "新しいリクエスト"
    guest = User.find(self.user_id)

    link_approved = "<a href = 'https://www.toollibrary.jp/guest_reservations'>#{guest.fullname}さんからの#{type}を承認しました</a>"

    link_declined = "<a href = 'https://www.toollibrary.jp/guest_reservations'>#{guest.fullname}さんからの#{type}を断りました</a>"

    if self.status == "Approved"
      Notification.create(content: "#{link_approved}", user_id: self.listing.user_id)
    end

    if self.status == "Declined"
      Notification.create(content: "#{link_declined}", user_id: self.listing.user_id)
    end

  end

  # ゲストへの通知
  def guest_create_notification
    type = self.listing.Instant? ? "新しい予約" : "新しいリクエスト"

    host = User.find(self.listing.user_id)

    link = "<a href = 'https://www.toollibrary.jp/my_reservations'>#{host.fullname}さんへの#{type}</a>"

    Notification.create(content: "#{link}", user_id: self.user_id)
  end

  def guest_update_notification
    type = self.listing.Instant? ? "新しい予約" : "新しいリクエスト"
    host = User.find(self.listing.user_id)

    link_approved = "<a href = 'https://www.toollibrary.jp/my_reservations'>#{host.fullname}さんへの#{type}が承認されました</a>"

    link_declined = "<a href = 'https://www.toollibrary.jp/my_reservations'>#{host.fullname}さんへの#{type}がお断りされました"

    if self.status == "Approved"
      Notification.create(content: "#{link_approved}", user_id: self.user_id)
    end

    if self.status == "Declined"
      Notification.create(content: "#{link_declined}", user_id: self.user_id)
    end

  end
end
