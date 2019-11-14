# frozen_string_literal: true

require_relative './../../cipher/elgamal/elgamal_user.rb'
require 'digest'

def public_pq
  pub_q = pub_p = 2
  loop do
    pub_q = Arithmetic.pprime(1e4)
    loop do
      b = rand(1e4)
      pub_p = b * pub_q + 1
      break if pub_p.prime?
    end
    break if pub_p.to_s[0].to_i + pub_q.to_s[0].to_i == 2
  end
  { pub_p: pub_p, pub_q: pub_q }
end

def public_a(pub_p, pub_q)
  pub_a = 2
  loop do
    pub_a = rand(1e5)
    break if Arithmetic.mod_exp(pub_a, pub_q, pub_p) == 1 && pub_a != 1
  end
  pub_a
end

# sender
class GOSTSender
  attr_reader :y_key

  CHUNK = 'L*'

  def initialize(pq_keys, alpha, message)
    @pub_p = pq_keys[:pub_p]
    @pub_q = pq_keys[:pub_q]
    @pub_a = alpha
    @x = 2 + rand(@pub_q)
    @y_key = Arithmetic.mod_exp(@pub_a, @x, @pub_p)
    @message = message
  end

  def hash(text)
    Digest::SHA256.hexdigest(text)
  end

  def sign_byte(byte)
    k = r = s = 2
    loop do
      loop do
        k = rand(@pub_q)
        r = (@pub_a.pow(k) % @pub_p) % @pub_q
        break if r > 2
      end
      s = (k * byte + @x * r) % @pub_q
      break if s.positive?
    end
    { r: r, s: s }
  end

  def sign
    hash = hash(@message)
    sgn = []
    hash.each_byte do |b|
      s = sign_byte(b)
      sgn << s[:r] << s[:s]
    end

    { signature: sgn.pack(CHUNK), message: @message }
  end
end

# reciever
class GOSTReceiver
  attr_writer :sender, :message

  CHUNK = 'L*'

  def initialize(pq_keys, alpha, message, sender)
    @pub_p = pq_keys[:pub_p]
    @pub_q = pq_keys[:pub_q]
    @pub_a = alpha
    @message = message
    @sender = sender
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
      return false unless (0..@pub_q).include?(s[0]) == (0..@pub_q).include?(s[1])

      h = Arithmetic.extended_gcd(hash[i].ord, @pub_q)
      h_inv = (h['x'] % @pub_q + @pub_q) % @pub_q

      u1 = (s[1] * h_inv) % @pub_q
      u2 = (-s[0] * h_inv) % @pub_q

      left = Arithmetic.mod_exp(@pub_a, u1, @pub_p)
      right = Arithmetic.mod_exp(@sender.y_key, u2, @pub_p)
      v = ((left * right) % @pub_p) % @pub_q

      rvalue << v
      lvalue << s[0]

      i += 1
    end

    rvalue == lvalue
  end
end
