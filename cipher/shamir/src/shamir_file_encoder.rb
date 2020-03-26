# frozen_string_literal: true

require_relative './shamir_adapter.rb'

# shamir file handler
class ShamirFileEncoder
  def initialize(input, output, chunk = 'L*')
    @input = input
    @output = output
    @chunk = chunk
  end

  def encode_file(alice_dump, bob_dump)
    modulus = Arithmetic.pprime
    alice = ShamirEncryptor.new(modulus)
    bob = ShamirDecryptor.new(modulus)
    adapter = ShamirAdapter.new(alice, bob)

    content = File.read(@input)
    File.open(@output, 'w') do |f|
      content.each_byte { |b| f.write([adapter.encode(b)].pack(@chunk)) }
    end

    File.write(alice_dump, Marshal.dump(alice))
    File.write(bob_dump, Marshal.dump(bob))
  end
end
