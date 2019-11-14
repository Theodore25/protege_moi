# frozen_string_literal: true

require_relative './../../cipher/rsa/rsa_user.rb'
require 'digest'

# sender
class RSASender < RSAUser
  attr_writer :message

  # uint_32
  CHUNK = 'L*'

  def initialize(message)
    super()

    @message = message
  end

  def hash(text)
    Digest::SHA256.hexdigest(text)
  end

  def sign
    sgn = []
    hash = hash(@message)
    hash.each_byte { |b| sgn << Arithmetic.mod_exp(b, @c_key, @modulus) }

    { signature: sgn.pack(CHUNK), message: @message }
  end
end

# receiver
class RSAReceiver
  attr_writer :sender, :message

  CHUNK = 'L*'

  def initialize(sender, message)
    super()

    @sender = sender
    @message = message
  end

  def hash(text)
    Digest::SHA256.hexdigest(text)
  end

  def verify?
    signature = @message[:signature].unpack(CHUNK)
    d_key = @sender.d_key
    mod = @sender.modulus

    hash = []
    signature.each { |b| hash << Arithmetic.mod_exp(b, d_key, mod) }

    sha256 = hash(@message[:message])
    sha256 = sha256.split('').map(&:ord)

    hash == sha256
  end
end
