# frozen_string_literal: true

# pseudo generator
class PseudoPrimeGenerator
  attr_reader :PRIME

  def initialize(bnd)
    @primes = Prime.take_while { |prime| prime < bnd }
  end

  def gen
    @primes[rand @primes.length]
  end
end
