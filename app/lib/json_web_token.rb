class JsonWebToken
  HMAC_SECRET = Rails.application.credentials.secret_key_base

  def self.encode(payload)
    expire_after = 24.hours.from_now
    payload[:exp] = expire_after.to_i
    JWT.encode(payload, HMAC_SECRET)
  end

  def self.decode(payload)
    token = JWT.decode(payload, HMAC_SECRET)[0]
    HashWithIndifferentAccess.new token
  end
end
