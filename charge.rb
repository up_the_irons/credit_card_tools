#!/usr/bin/env ruby

$:.unshift File.join(File.dirname(__FILE__))

$AMOUNT     = ARGV[0]
$CCNUM      = ARGV[1]
$CCEXP      = ARGV[2]
$FIRST_NAME = ARGV[3]
$LAST_NAME  = ARGV[4]

def usage
  puts "./charge.rb <amount> <ccnum> <ccexp> [first_name] [last_name]"
  puts ""
  puts "Note: <ccexp> must be of form 'xx/yyyy'"
end

# Convert dollars to cents
$AMOUNT = ($AMOUNT.to_f * 100).to_i unless $AMOUNT.nil?

unless $AMOUNT && $CCNUM && $CCEXP
  usage
  exit
end

require 'rubygems'
require 'active_merchant'

# Provides @gateway instance
require 'gateway'

$CCEXP_MONTH, $CCEXP_YEAR = $CCEXP.split('/')

creditcard = ActiveMerchant::Billing::CreditCard.new(
  :number     => $CCNUM,
  :month      => $CCEXP_MONTH,
  :year       => $CCEXP_YEAR,
  :first_name => $FIRST_NAME,
  :last_name  => $LAST_NAME
)

response = @gateway.purchase($AMOUNT, creditcard, :ip => '127.0.0.1')

puts response.to_yaml
