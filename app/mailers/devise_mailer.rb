class DeviseMailer < Devise::Mailer
  def confirmation_instructions(record, token, opts={})
    options = opts.merge default_opts
    @token = token
    devise_mail(record, :confirmation_instructions, opts)
  end


  private

  def default_opts
   {
       bcc: "s-kawabata@digisurf.co.jp"
   }
  end

end
