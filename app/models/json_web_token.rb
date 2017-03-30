class JsonWebToken
  def self.encode(payload)
    JWT.encode payload, Rails.application.secrets.secret_key_base
  end

  def self.decode(token, first = true)
    decoded = JWT.decode(token, Rails.application.secrets.secret_key_base)
    return first ? decoded.first : decoded
  end
end
