class ApplyController < ApplicationController
  # 入力画面を表示
  def index
    @apply = Apply.new
    render :action => 'index'
  end

  # 入力値のチェック
  def confirm
    @apply = Apply.new(apply_params)
    if @apply.valid?
     # OK。確認画面を表示
     render :action => 'confirm'
    else
     # NG。入力画面を再表示
     render :action => 'index'
    end
  end

  # メール送信
  def thanks
    @apply = Apply.new(apply_params)
    ApplyMailer.sent_email(@apply).deliver
    ApplyMailer.received_email(@apply).deliver

    # 完了画面を表示
    render :action => 'thanks'
  end

  private

  def apply_params
    params.require(:apply).permit(:name, :email, :message, :address, :phone_number)
  end

end
