config = YAML.load(File.read('gateway.yml'))

$API_LOGIN        = config['api_login']
$API_PASSWORD     = config['api_password']
$API_KEY_FILENAME = config['api_key_filename']

@gateway = ActiveMerchant::Billing::PaypalGateway.new(
  :login    => $API_LOGIN,
  :password => $API_PASSWORD,
  :pem      => File.read(File.join($API_KEY_FILENAME)))
