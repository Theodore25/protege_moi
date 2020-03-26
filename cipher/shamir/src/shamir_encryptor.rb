# frozen_string_literal: true

require_relative 'shamir_user.rb'

# shamir's three-pass protocol
class ShamirEncryptor < ShamirUser
  def initialize(modulus)
    super(modulus)
  end

  def encrypt_first_pass(message)
    base(message)
  end

  def encrypt_second_pass(message)
    power(message)
  end
end
