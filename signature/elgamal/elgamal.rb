# frozen_string_literal: true

require_relative './../../cipher/elgamal/srcelgamal_user.rb'
require 'digest'

# sender
class ElgamalSender < ElgamalUser
  attr_writer :message

  # uint_32
  CHUNK = 'L*'

  def initialize(message, modulus, generator)
    super(modulus, generator)

    @message = message
  end

  def hash(text)
    Digest::SHA256.hexdigest(text)
  end

  def initialize_cd
    m = @modulus - 1
    @sid = @inv = rand(m)
    loop do
      @sid = rand(m)
      h = Arithmetic.extended_gcd(@sid, m)
      if h['gcd'] == 1
        @inv = (h['x'] % m + m) % m
        break
      end
    end
  end

  def sign
    sgn = []
    hash = hash(@message)
    hash.each_byte do |b|
      initialize_cd

      r = Arithmetic.mod_exp(@generator, @sid, @modulus)
      u = (b - @x_key * r) % (@modulus - 1)
      s = (@inv * u) % (@modulus - 1)

      sgn << r << s
    end
    { signature: sgn.pack(CHUNK), message: @message }
  end
end

# receiver
class ElgamalReceiver
  attr_writer :sender, :message

  CHUNK = 'L*'

  def initialize(sender, message, modulus, generator)
    @sender = sender
    @message = message
    @generator = generator
    @modulus = modulus
  end

  def hash(text)
    Digest::SHA256.hexdigest(text)
  end

  def verify?
    signature = @message[:signature].unpack(CHUNK)
    hash = hash(@message[:message])

    rvalue = []
    lvalue = []
    i = 0
    signature.each_slice(2) do |s|
      rvalue << Arithmetic.mod_exp(@generator, hash[i].ord, @sender.modulus)
      a = Arithmetic.mod_exp(@sender.y_key, s[0], @sender.modulus)
      b = Arithmetic.mod_exp(s[0], s[1], @sender.modulus)
      lvalue << (a * b) % @sender.modulus
      i += 1
    end
    rvalue == lvalue
  end
end
