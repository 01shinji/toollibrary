class InquiryController < ApplicationController
  # 入力画面を表示
  def index
    @inquiry = Inquiry.new
    render :action => 'index'
  end

  # 入力値のチェック
  def confirm
    @inquiry = Inquiry.new(inquiry_params)
    if @inquiry.valid?
     # OK。確認画面を表示
     render :action => 'confirm'
    else
     # NG。入力画面を再表示
     render :action => 'index'
    end
  end

  # メール送信
  def thanks
    @inquiry = Inquiry.new(inquiry_params)
    InquiryMailer.sent_email(@inquiry).deliver
    InquiryMailer.received_email(@inquiry).deliver

    # 完了画面を表示
    render :action => 'thanks'
  end

  private

  def inquiry_params
    params.require(:inquiry).permit(:name, :email, :message)
  end

end
