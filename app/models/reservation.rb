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

    Notification.create(content: "#{guest.fullname}さんからの#{type}", user_id: self.listing.user_id)
  end

  def host_update_notification
    type = self.listing.Instant? ? "新しい予約" : "新しいリクエスト"
    guest = User.find(self.user_id)

    if self.status == "Approved"
      Notification.create(content: "#{guest.fullname}さんからの#{type}を承認しました", user_id: self.listing.user_id)
    end

    if self.status == "Declined"
      Notification.create(content: "#{guest.fullname}さんからの#{type}を断りました", user_id: self.listing.user_id)
    end

  end

  # ゲストへの通知
  def guest_create_notification
    type = self.listing.Instant? ? "新しい予約" : "新しいリクエスト"

    host = User.find(self.listing.user_id)

    Notification.create(content: "#{host.fullname}さんへの#{type}", user_id: self.user_id)
  end

  def guest_update_notification
    type = self.listing.Instant? ? "新しい予約" : "新しいリクエスト"
    host = User.find(self.listing.user_id)

    if self.status == "Approved"
      Notification.create(content: "#{host.fullname}さんへの#{type}が承認されました", user_id: self.user_id)
    end

    if self.status == "Declined"
      Notification.create(content: "#{host.fullname}さんへの#{type}がお断りされました", user_id: self.user_id)
    end

  end
end
