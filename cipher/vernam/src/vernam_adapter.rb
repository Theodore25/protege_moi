# frozen_string_literal: true

require_relative './vernam_encryptor.rb'
require_relative './vernam_decryptor.rb'

# vernam adapter
class VernamAdapter
  def initialize(alice, bob)
    @alice = alice
    @bob = bob
  end

  def encode(message)
    @alice.encrypt(message.ord)
  end

  def decode(cipher)
    @bob.decrypt(cipher, @alice.key)
  end
end
