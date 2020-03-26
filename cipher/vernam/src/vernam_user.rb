# frozen_string_literal: true

require_relative './../../../modular/arithmetic.rb'

# vernam user
class VernamUser
  include Arithmetic

  attr_reader :key

  def initialize
    @key = Arithmetic.pprime
  end
end
