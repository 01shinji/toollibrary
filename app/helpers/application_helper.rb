module ApplicationHelper
  def stripe_express_path
    "https://connect.stripe.com/express/oauth/authorize?response_type=code&client_id=ca_CFtY2gH6iAeDCdShvLTkvNdES53P1JAA&scope=read_write"
  end
end
