# frozen_string_literal: true

require_relative 'rsa.rb'

message = File.read(ARGV[0])

alice = RSASender.new(message)
alice_parcel = alice.sign

melory = RSASender.new(message)
melory_parcel = melory.sign

# verification
puts RSAReceiver.new(alice, alice_parcel).verify?
puts RSAReceiver.new(melory, alice_parcel).verify?
puts RSAReceiver.new(alice, melory_parcel).verify?
puts RSAReceiver.new(melory, melory_parcel).verify?

# puts(alice_parcel[:signature].unpack('L*').each_slice(2) { |s| print("#{s[0]}, #{s[1]}\n")} )
