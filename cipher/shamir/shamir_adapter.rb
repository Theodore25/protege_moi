# frozen_string_literal: true

require_relative './shamir_encryptor.rb'
require_relative './shamir_decryptor.rb'

# shamir adapter
class ShamirAdapter
  def initialize(alice, bob)
    @alice = alice
    @bob = bob
  end

  def encode(message)
    alice_base = @alice.encrypt_first_pass(message)
    bob_base = @bob.decrypt_first_pass(alice_base)
    @alice.encrypt_second_pass(bob_base)
  end

  def decode(cipher)
    @bob.decrypt_second_pass(cipher)
  end
end
