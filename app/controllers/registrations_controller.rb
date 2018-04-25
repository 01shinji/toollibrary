class RegistrationsController < Devise::RegistrationsController
  protected
    def update_resource(resource, params)
      resource.update_without_password(params)
    end

    def address2
      "%s%s%s"%([self.address_prefecture_name,self.address_city,self.address_street])
    end

end
