#!/usr/bin/env ruby

require 'rubygems'
require 'active_merchant'

# Provides @gateway instance
require 'my_gateway'

def usage
  puts "./refund.rb <amount> <auth_id>"
end

$AMOUNT  = ARGV[0]
$AUTH_ID = ARGV[1]

# Convert dollars to cents
$AMOUNT = ($AMOUNT.to_f * 100).to_i unless $AMOUNT.nil?

unless $AMOUNT && $AUTH_ID
  usage
  exit
end

response = @gateway.credit($AMOUNT.to_i, $AUTH_ID)

puts response.to_yaml
