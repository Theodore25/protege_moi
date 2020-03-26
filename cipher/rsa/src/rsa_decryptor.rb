# frozen_string_literal: true

require_relative 'rsa_user.rb'

# rsa decryptor
class RSADecryptor < RSAUser
  def initialize
    super()
  end

  def decrypt(cipher)
    Arithmetic.mod_exp(cipher, @c_key, @modulus)
  end
end
