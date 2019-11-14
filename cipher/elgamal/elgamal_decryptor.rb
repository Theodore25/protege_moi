# frozen_string_literal: true

require_relative 'elgamal_user.rb'

# elgamal decryptor
class ElgamalDecryptor < ElgamalUser
  def initialize(modulus, generator)
    super(modulus, generator)
  end

  def alpha_decrypt(alpha, exponent)
    Arithmetic.mod_exp(alpha, exponent, @modulus)
  end

  def beta_decrypt(beta)
    beta % @modulus
  end

  def decrypt(cipher)
    alpha = alpha_decrypt(cipher[:alpha], @modulus - 1 - @x_key)
    beta = beta_decrypt(cipher[:beta])
    (alpha * beta) % @modulus
  end
end
