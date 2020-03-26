# frozen_string_literal: true

require_relative './rsa_adapter.rb'

class RSAFileDecoder
  def initialize(input, output, chunk = 'L*')
    @input = input
    @output = output
    @chunk = chunk
  end

  def decode_file(alice, bob)
    adapter = RSAAdapter.new(alice, bob)

    content = File.read(@input).unpack(@chunk)
    File.open(@output, 'w') do |f|
      content.each { |b| f.write(adapter.decode(b).chr) }
    end
  end
end
