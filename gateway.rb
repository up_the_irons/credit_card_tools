config = YAML.load(File.read(File.join(File.dirname(__FILE__), 'gateway.yml')))

mode = config['live']['enabled'] ? 'live' : 'test'

$API_LOGIN        = config[mode]['api_login']
$API_PASSWORD     = config[mode]['api_password']
$API_KEY_FILENAME = config[mode]['api_key_filename']

if mode == 'test'
  ActiveMerchant::Billing::Base.mode = :test
  ActiveMerchant::Billing::CreditCard.require_verification_value = false
end

@gateway = ActiveMerchant::Billing::PaypalGateway.new(
  { :login     => $API_LOGIN,
    :password  => $API_PASSWORD }.merge(
  mode == 'live' ? 
  { :pem       => File.read(File.join(File.dirname(__FILE__), $API_KEY_FILENAME)) } :
  { :signature => config['test']['api_signature'] }))
