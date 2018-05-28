class EntryController < ApplicationController
  # 入力画面を表示
  def index
    @entry = Entry.new
    render :action => 'index'
  end

  # 入力値のチェック
  def confirm
    @entry = Entry.new(entry_params)
    if @entry.valid?
     # OK。確認画面を表示
     render :action => 'confirm'
    else
     # NG。入力画面を再表示
     render :action => 'index'
    end
  end

  # メール送信
  def thanks
    @entry = Entry.new(entry_params)
    EntryMailer.sent_email(@entry).deliver
    EntryMailer.received_email(@entry).deliver

    # 完了画面を表示
    render :action => 'thanks'
  end

  private

  def entry_params
    params.require(:entry).permit(:name, :email, :message, :address, :phone_number, :product)
  end

end
