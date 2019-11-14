# frozen_string_literal: true

require_relative 'shamir_user.rb'

# shamir's three-pass protocol
class ShamirDecryptor < ShamirUser
  def initialize(modulus)
    super(modulus)
  end

  def decrypt_first_pass(cipher)
    base(cipher)
  end

  def decrypt_second_pass(cipher)
    power(cipher)
  end
end
