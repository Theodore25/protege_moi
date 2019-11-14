# frozen_string_literal: true

require_relative './../../modular/arithmetic.rb'

# rsa user
class RSAUser
  include Arithmetic

  attr_reader :d_key, :modulus

  def initialize
    initialize_modulus
    initialize_keys
  end

  def initialize_modulus
    @p = Arithmetic.pprime(1e4)
    @q = (@p - 1).div 2
    @modulus = @p * @q
  end

  def initialize_keys
    phi = (@p - 1) * (@q - 1)
    loop do
      @c_key = rand(phi)
      hash = Arithmetic.extended_gcd(@c_key, phi)
      if hash['gcd'] == 1
        @d_key = (hash['x'] % phi + phi) % phi
        break
      end
    end
  end
end
