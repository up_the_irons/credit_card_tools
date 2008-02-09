#!/usr/bin/env ruby

$:.unshift File.join(File.dirname(__FILE__))

$AMOUNT     = ARGV[0]
$CCNUM      = ARGV[1]
$CCEXP      = ARGV[2]
$FIRST_NAME = ARGV[3]
$LAST_NAME  = ARGV[4]
$CVV2       = ARGV[5]

# Optional billing address
$BILLING_NAME    = ARGV[6]
$BILLING_ADDR    = ARGV[7]
$BILLING_CITY    = ARGV[8]
$BILLING_STATE   = ARGV[9]
$BILLING_ZIP     = ARGV[10]
$BILLING_COUNTRY = ARGV[11]
$BILLING_PHONE   = ARGV[12]

def usage
  puts "./charge.rb <amount> <ccnum> <ccexp> [cvv2] [first_name] [last_name] [billing_name] [billing_address] [billing_city] [billing_state] [billing_zip] [billing_country] [billing_phone]"
  puts ""
  puts "Note: <ccexp> must be of form 'xx/yyyy'"
  puts ""
  puts "To enter an empty string for any optional argument, put \"\" (empty set of quotes)"
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

cc_hash = { 
  :number     => $CCNUM,
  :month      => $CCEXP_MONTH.to_i,
  :year       => $CCEXP_YEAR,
  :first_name => $FIRST_NAME,
  :last_name  => $LAST_NAME 
}

unless $CVV2.nil? || $CVV2.empty?
  cc_hash.merge!(:verification_value => $CVV2)
end

creditcard = ActiveMerchant::Billing::CreditCard.new(cc_hash)

if $BILLING_NAME
  @billing_address = { :name => $BILLING_NAME, :address1 => $BILLING_ADDR, :city => $BILLING_CITY, :state => $BILLING_STATE, :zip => $BILLING_ZIP, :country => $BILLING_COUNTRY, :phone => $BILLING_PHONE }
end

response = @gateway.purchase($AMOUNT, creditcard, :ip => '127.0.0.1', :billing_address => @billing_address)

puts response.to_yaml
