# frozen_string_literal: true

require_relative './shamir_adapter.rb'

# shamir file handler
class ShamirFileHandler
  def initialize(reader, writer, cipher = 'ciph', chunk = 'L*')
    @reader = reader
    @writer = writer
    @chunk = chunk
    @cipher = cipher

    initialize_channel
  end

  def initialize_channel
    modulus = Arithmetic.pprime
    alice = ShamirEncryptor.new(modulus)
    bob = ShamirDecryptor.new(modulus)
    @adapter = ShamirAdapter.new(alice, bob)
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
