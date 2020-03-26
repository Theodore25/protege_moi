# frozen_string_literal: true

require_relative 'rsa_user.rb'

# rsa encryptor
class RSAEncryptor < RSAUser
  def initialize
    super()
  end

  def encrypt(message, d_key, modulus)
    Arithmetic.mod_exp(message, d_key, modulus)
  end
end
