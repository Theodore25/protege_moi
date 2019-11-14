# frozen_string_literal: true

require_relative 'elgamal.rb'

message = File.read(ARGV[0])

modulus = Arithmetic.pprime
generator = Arithmetic.generator(modulus)

alice = ElgamalSender.new(message, modulus, generator)
alice_parcel = alice.sign

melory = ElgamalSender.new(message, modulus, generator)
melory_parcel = melory.sign

puts ElgamalReceiver.new(alice, alice_parcel, modulus, generator).verify?
puts ElgamalReceiver.new(melory, alice_parcel, modulus, generator).verify?
puts ElgamalReceiver.new(alice, melory_parcel, modulus, generator).verify?
puts ElgamalReceiver.new(melory, melory_parcel, modulus, generator).verify?
