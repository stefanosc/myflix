CarrierWave.configure do |config|

  if Rails.env.production? || Rails.env.staging?
    config.fog_credentials = {
        :provider               => 'AWS',
        :aws_access_key_id      => ENV['AWS_ACCESS_KEY_ID'],
        :aws_secret_access_key  => ENV['AWS_SECRET_ACCESS_KEY']
      }
    config.fog_directory  = 'loveflix'
    config.fog_public     = true
    config.fog_attributes = {'Cache-Control'=>'max-age=2628000'}
    config.storage = :fog
  else
    config.storage = :file
    config.root = "#{Rails.root}/public"
  end

  if Rails.env.test?
    config.enable_processing = false
    config.root = "#{Rails.root}/tmp"
  end
end