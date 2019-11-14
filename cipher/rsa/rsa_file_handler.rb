# frozen_string_literal: true

require_relative './rsa_adapter.rb'

# rsa file handler
class RSAFileHandler
  def initialize(reader, writer, cipher = 'ciph', chunk = 'L*')
    @reader = reader
    @writer = writer
    @chunk = chunk
    @cipher = cipher

    initialize_channel
  end

  def initialize_channel
    alice = RSAEncryptor.new
    bob = RSADecryptor.new
    @adapter = RSAAdapter.new(alice, bob)
  end

  def encode_file
    content = File.read(@reader)
    File.open(@cipher, 'w') do |f|
      content.each_byte { |b| f.write([@adapter.encode(b)].pack(@chunk)) }
    end
  end

  def decode_file
    content = File.read(@cipher).unpack(@chunk)
    File.open(@writer, 'w') do |f|
      content.each { |b| f.write(@adapter.decode(b).chr) }
    end
  end
end
