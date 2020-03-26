# frozen_string_literal: true

require_relative 'vernam_user.rb'

# vernam encryptor
class VernamEncryptor < VernamUser
  def initialize
    super()
  end

  def encrypt(message)
    message ^ @key
  end
end
