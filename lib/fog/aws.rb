require 'fog/aws/version'

module Fog
  module AWS
  end
end

require File.expand_path('../aws/core', __FILE__)

require File.expand_path('../aws/auto_scaling', __FILE__)
require File.expand_path('../aws/beanstalk', __FILE__)
require File.expand_path('../aws/cdn', __FILE__)
require File.expand_path('../aws/cloud_formation', __FILE__)
require File.expand_path('../aws/cloud_watch', __FILE__)
require File.expand_path('../aws/compute', __FILE__)
require File.expand_path('../aws/data_pipeline', __FILE__)
require File.expand_path('../aws/dns', __FILE__)
require File.expand_path('../aws/dynamodb', __FILE__)
require File.expand_path('../aws/elasticache', __FILE__)
require File.expand_path('../aws/elb', __FILE__)
require File.expand_path('../aws/emr', __FILE__)
require File.expand_path('../aws/federation', __FILE__)
require File.expand_path('../aws/glacier', __FILE__)
require File.expand_path('../aws/iam', __FILE__)
require File.expand_path('../aws/rds', __FILE__)
require File.expand_path('../aws/redshift', __FILE__)
require File.expand_path('../aws/ses', __FILE__)
require File.expand_path('../aws/simpledb', __FILE__)
require File.expand_path('../aws/sns', __FILE__)
require File.expand_path('../aws/sqs', __FILE__)
require File.expand_path('../aws/storage', __FILE__)
require File.expand_path('../aws/sts', __FILE__)
