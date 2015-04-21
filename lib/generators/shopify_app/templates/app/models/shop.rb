class Shop < ActiveRecord::Base
  def self.store(session)
    #add code here to keep it from adding a new shop if one is there already
    shop = Shop.find_by(:domain => session.url)
    if shop == nil
      shop = Shop.new(domain: session.url, token: session.token)
      shop.save!
    else
      shop.token = session.token
      shop.save!
      ShopifyAPI::Session.new(shop.domain, shop.token)
    end
    shop.id
  end

  def self.retrieve(id)
    if shop = Shop.where(id: id).first
      ShopifyAPI::Session.new(shop.domain, shop.token)
    end
  end

  def shopify_api_path
    "https://#{ShopifyApp.configuration.api_key}:#{self.token}@#{self.domain}/admin"
  end

  def new_sess
    ShopifyAPI::Base.activate_session(Shop.retrieve(self.id))
  end
end
