module ApplicationHelper
  def stripe_express_path
    "https://connect.stripe.com/express/oauth/authorize?response_type=code&client_id=ca_CFtY2gH6iAeDCdShvLTkvNdES53P1JAA&scope=read_write"
  end

  require "uri"

  def text_url_to_link text
    URI.extract(text, ['http','https']).uniq.each do |url|
      sub_text = ""
      sub_text << "<a href=" << url << " target=\"_blank\">" << url << "</a>"

      text.gsub!(url, sub_text)
    end

    return text
  end

end
