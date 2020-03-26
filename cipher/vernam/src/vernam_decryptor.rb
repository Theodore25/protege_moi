# frozen_string_literal: true

require_relative 'vernam_user.rb'

# vernam encryptor
class VernamDecryptor < VernamUser
  def initialize
    super()
  end

  def decrypt(cipher, key)
    cipher ^ key
  end
end
