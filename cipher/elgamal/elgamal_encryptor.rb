# frozen_string_literal: true

require_relative 'elgamal_user.rb'

# elgamal encryptor
class ElgamalEncryptor < ElgamalUser
  def initialize(modulus, generator)
    super(modulus, generator)
  end

  def alpha_encrypt(sid)
    Arithmetic.mod_exp(@generator, sid, @modulus)
  end

  def beta_encrypt(y_key, sid, message)
    Arithmetic.mod_exp(y_key, sid, @modulus) * message % @modulus
  end

  def encrypt(message, sid, y_key)
    alpha = alpha_encrypt(sid)
    beta = beta_encrypt(y_key, sid, message)
    { alpha: alpha, beta: beta }
  end
end
