# frozen_string_literal: true

require_relative './random_prime.rb'

# modular arithmetic
module Arithmetic
  module_function

  # find generator
  def generator(modulus)
    qprime = (modulus.div 2) - 1
    generator = 0
    loop do
      generator = rand(modulus)
      y = mod_exp(generator, qprime, modulus)
      break if y > 11
    end
    generator
  end

  # generate pprime, p = 2q + 1
  def pprime(bnd = 1e6)
    require 'prime'

    prime_generator = PseudoPrimeGenerator.new(bnd)
    pprime = prime_generator.gen
    loop do
      pprime = prime_generator.gen
      break if ((pprime - 1).div 2).prime?
    end
    pprime
  end

  # modular exponentiation
  def mod_exp(base, exponent, modulus)
    y = 1
    base = base % modulus
    until exponent.zero?
      y = (y * base) % modulus if exponent.odd?
      exponent >>= 1
      base = (base * base) % modulus
    end
    y
  end

  # gcd
  def gcd(alpha, beta)
    until beta.zero?
      phi = alpha % beta
      alpha = beta
      beta = phi
    end
    alpha
  end

  def extended_gcd(alpha, beta)
    u = alpha, 1, 0
    v = beta, 0, 1
    until v[0].zero?
      q = u[0].div v[0]
      t = u[0] % v[0], u[1] - q * v[1], u[2] - q * v[2]
      u = v
      v = t
    end
    { 'gcd' => u[0], 'x' => u[1], 'y' => u[2] }
  end

  # baby step, giant step
  def discrete_logarithm(beta, alpha, modulus, exponent=-1)
    # n-step
    n = (Math.sqrt(modulus) + 1).to_i
    # giant step
    giant = {}
    (0..n - 1).each { |i| giant[mod_exp(alpha, i * n, modulus)] = i }
    # baby step
    (0..n - 1).each do |j|
      baby = (mod_exp(alpha, j, modulus) * beta) % modulus
      if giant[baby]
        exponent = giant[baby] * n - j
        break if exponent < mod
      end
    end
    exponent
  end
end

# def extended_gcd_iter(alpha, beta)
#   return 1, 0 if beta.zero?

#   q, r = alpha.divmod beta
#   s, t = extended_gcd_iter(beta, r)
#   [t, s - q * t]
# end

# def extended_gcd(alpha, beta)
#   x, y = extended_gcd_iter(alpha, beta)
#   { gcd: alpha * x + beta * y, x: x, y: y }
# end
