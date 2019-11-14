# frozen_string_literal: true

require_relative 'gost.rb'

message = File.read(ARGV[0])

pq = public_pq
a = public_a(pq[:pub_p], pq[:pub_q])

alice = GOSTSender.new(pq, a, message)
alice_parcel = alice.sign

melory = GOSTSender.new(pq, a, message)
melory_parcel = melory.sign

puts GOSTReceiver.new(pq, a, alice_parcel, alice).verify?
puts GOSTReceiver.new(pq, a, melory_parcel, alice).verify?
puts GOSTReceiver.new(pq, a, alice_parcel, melory).verify?
puts GOSTReceiver.new(pq, a, melory_parcel, melory).verify?
