module JwtToken
  
  SECRET_KEY = ENV['JWT_SECRET_KEY']
  ALGORITHM = 'HS256'

  def self.generate(payload, exp=nil)
    payload[:exp] = exp&.to_i if exp.present?
    payload[:iat] = Time.now.to_i
    JWT.encode(payload, SECRET_KEY, ALGORITHM)
  end

  def self.verify(token)
    return nil if token.blank?
    decoded = JWT.decode(token, SECRET_KEY, true, { algorithm: ALGORITHM })[0]
    HashWithIndifferentAccess.new(decoded)
  rescue JWT::ExpiredSignature
    puts ">>>>>>>>>>>>>>>>>>> Token has expired"
    nil
  rescue JWT::DecodeError => e
    puts ">>>>>>>>>>>>>>>>   #{e.message}"
    puts ">>>>>>>>>>>>>>>>>>> Invalid token"
    nil
  end
end