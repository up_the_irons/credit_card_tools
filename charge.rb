#!/usr/bin/env ruby

require 'rubygems'
require 'active_merchant'

# Provides @gateway instance
require 'my_gateway'

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

unless $AMOUNT && $CCNUM && $CCEXP
  usage
  exit
end

$CCEXP_MONTH, $CCEXP_YEAR = $CCEXP.split('/')

creditcard = ActiveMerchant::Billing::CreditCard.new(
  :number     => $CCNUM,
  :month      => $CCEXP_MONTH,
  :year       => $CCEXP_YEAR,
  :first_name => $FIRST_NAME,
  :last_name  => $LAST_NAME
)

response = @gateway.purchase($AMOUNT, creditcard, :ip => '208.79.88.31')

puts response.to_yaml
