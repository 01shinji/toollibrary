module ApplicationHelper
  def stripe_express_path    
    "https://connect.stripe.com/express/oauth/authorize?response_type=code&client_id=ca_CFtYh8UW9pMtOBA6WGsQCqFyFwxOEKol&scope=read_write"
  end
end
