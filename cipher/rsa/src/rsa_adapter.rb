# frozen_string_literal: true

require_relative './rsa_encryptor.rb'
require_relative './rsa_decryptor.rb'

# rsa adapter
class RSAAdapter
  def initialize(alice, bob)
    @alice = alice
    @bob = bob
  end

  def encode(message)
    @alice.encrypt(message.ord, @bob.d_key, @bob.modulus)
  end

  def decode(cipher)
    @bob.decrypt(cipher)
  end
end
