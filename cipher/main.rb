# frozen_string_literal: true

require_relative './shamir/shamir_file_handler.rb'
require_relative './elgamal/elgamal_file_handler.rb'
require_relative './rsa/rsa_file_handler.rb'
require_relative './nvernam/vernam_file_handler.rb'

reader = './target/original_giphy.gif'
writer = './target/decoded_giphy.gif'
cipher = './target/vernam_giphy.gif.cipher'

# handler = ShamirFileHandler.new(reader, writer, cipher)
# handler.encode_file
# handler.decode_file

# handler = ElgamalFileHandler.new(reader, writer, cipher)
# handler.encode_file
# handler.decode_file

# handler = RSAFileHandler.new(reader, writer, cipher)
# handler.encode_file
# handler.decode_file

handler = VernamFileHandler.new(reader, writer, cipher)
handler.encode_file
handler.decode_file
