#!/usr/bin/env ruby

# Ruby script for listing all avaliable teams for iTunes Connect

require 'spaceship'

itunes_connect_username = ARGV[0]
itunes_connect_password = ARGV[1]

Spaceship::Tunes.login(itunes_connect_username, itunes_connect_password)

client = Spaceship::Tunes.client

puts("\nHere are your avaliable iTunes Connect Teams:\n")

client.teams.each_with_index do |team, i|
    puts("#{i + 1}) \"#{team['contentProvider']['name']}\" (#{team['contentProvider']['contentProviderId']})")
end