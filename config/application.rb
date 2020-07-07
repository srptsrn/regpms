# encoding: utf-8

require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module REGPMS
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'
    config.time_zone = 'Bangkok'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '*.{rb,yml}').to_s]
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', 'models', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :th
    
    config.action_mailer.default_url_options = {:host => "localhost:3000"}
  end
end

require "currency_extensions"
require "date_thai_format"

$ELEAVE_SITE = "https://baadleave.ibatt.in.th"

$DEFAULT_LOGIN_LAYOUT = "orb_login"
$DEFAULT_LAYOUT = "orb"

$LOCALES = [["TH", "th"], ["EN", "en"]]

# mailgun.org
# noreply.kku.library@gmail.com
# noreply.kku.library1q2w3e4r

$EMAIL_AUTHENTICATION = :plain
$EMAIL_ADDRESS = "smtp.mailgun.org"
$EMAIL_PORT = 587
$EMAIL_DOMAIN = "ibatt.in.th"
$EMAIL_FROM = "ประเมินผลการปฏิบัติราชการ สำนักบริหารและพัฒนาวิชาการ <noreply@ibatt.in.th>"
$EMAIL_USER_NAME = "baad@ibatt.in.th"
$EMAIL_PASSWORD = "baad1q2w3e4r"
ActionMailer::Base.smtp_settings = {
  :authentication => $EMAIL_AUTHENTICATION, 
  :address => $EMAIL_ADDRESS,
  :port => $EMAIL_PORT,
  :domain => $EMAIL_DOMAIN,
  :user_name => $EMAIL_USER_NAME,
  :password => $EMAIL_PASSWORD
}