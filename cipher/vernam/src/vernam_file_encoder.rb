# frozen_string_literal: true

require_relative './vernam_adapter.rb'

class VernamFileEncoder
  def initialize(input, output, chunk = 'L*')
    @input = input
    @output = output
    @chunk = chunk
  end

  def encode_file(alice_dump, bob_dump)
    alice = VernamEncryptor.new
    bob = VernamDecryptor.new
    adapter = VernamAdapter.new(alice, bob)

    content = File.read(@input)
    File.open(@output, 'w') do |f|
      content.each_byte { |b| f.write([adapter.encode(b)].pack(@chunk)) }
    end

    File.write(alice_dump, Marshal.dump(alice))
    File.write(bob_dump, Marshal.dump(bob))
  end
end
