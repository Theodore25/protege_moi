# frozen_string_literal: true

require_relative './../../modular/arithmetic.rb'

# elgamal user
class ElgamalUser
  include Arithmetic

  # x_key is private

  attr_reader :y_key, :modulus

  def initialize(modulus, generator)
    @modulus = modulus
    @generator = generator

    initialize_keys
  end

  def initialize_keys
    @x_key = rand(1e4)
    @y_key = Arithmetic.mod_exp(@generator, @x_key, @modulus)
  end
end
