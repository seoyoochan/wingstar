CarrierWave.configure do |config|
  config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => ENV['S3_KEY'],
      :aws_secret_access_key  => ENV['S3_SECRET']
      # :region                 => ENV['S3_REGION'] # Change this for different AWS region. Default is 'us-east-1'
  }
  config.fog_directory  = ENV['S3_BUCKET']
end

# If you are on unix machine, add the following code in your ~/.bash_profile, and
# run source to reload it, otherwise hardcoded the value of your access id,
# key and bucket in step 5.
#
# #aws s3
# export S3_KEY="SecretKeyFromAWS"
# export S3_SECRET="SecRetKEy"
# export S3_BUCKET="bucketname"