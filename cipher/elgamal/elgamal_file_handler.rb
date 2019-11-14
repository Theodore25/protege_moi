# frozen_string_literal: true

require_relative './../../modular/arithmetic.rb'
require_relative './elgamal_adapter.rb'

# shamir file handler
class ElgamalFileHandler
  def initialize(reader, writer, cipher = 'ciph', chunk = 'L*')
    @reader = reader
    @writer = writer
    @chunk = chunk
    @cipher = cipher

    initialize_channel
  end

  def initialize_channel
    modulus = Arithmetic.pprime
    generator = Arithmetic.generator(modulus)
    alice = ElgamalEncryptor.new(modulus, generator)
    bob = ElgamalDecryptor.new(modulus, generator)
    @adapter = ElgamalAdapter.new(alice, bob)
  end

  def encode_file
    content = File.read(@reader)

    File.open(@cipher, 'w') do |f|
      content.each_byte { |b| f.write(@adapter.encode(b).values.pack(@chunk)) }
    end
  end

  def decode_file
    content = File.read(@cipher).unpack(@chunk)
    File.open(@writer, 'w') do |f|
      content.each_slice(2) do |c|
        ciph = { alpha: c.first, beta: c.last }
        f.write(@adapter.decode(ciph).chr)
      end
    end
  end
end
