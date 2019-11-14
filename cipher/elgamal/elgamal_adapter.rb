# frozen_string_literal: true

require_relative './elgamal_encryptor.rb'
require_relative './elgamal_decryptor.rb'

# shamir adapter
class ElgamalAdapter
  def initialize(alice, bob)
    @alice = alice
    @bob = bob
  end

  def encode(message)
    sid = rand(@alice.modulus)
    @alice.encrypt(message, sid, @bob.y_key)
  end

  def decode(cipher)
    @bob.decrypt(cipher)
  end
end
