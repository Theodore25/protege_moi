# frozen_string_literal: true

require_relative './../../modular/arithmetic.rb'

# shamir user
class ShamirUser
  include Arithmetic

  def initialize(modulus)
    @modulus = modulus
    initialize_keys
  end

  # (c * d) mod (p - 1) = 1
  def initialize_keys
    m = @modulus - 1
    loop do
      @c_key = rand(1e6)
      hash = Arithmetic.extended_gcd(@c_key, m)
      if hash['gcd'] == 1
        @d_key = (hash['x'] % m + m) % m
        break
      end
    end
  end

  # get base
  def base(message)
    Arithmetic.mod_exp(message, @c_key, @modulus)
  end

  # get power
  def power(base)
    Arithmetic.mod_exp(base, @d_key, @modulus)
  end
end
