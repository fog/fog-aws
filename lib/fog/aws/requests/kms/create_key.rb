module Fog
  module AWS
    class KMS
      class Real
        require 'fog/aws/parsers/kms/describe_key'

        def create_key(policy = nil, description = nil, usage = "ENCRYPT_DECRYPT")
          request(
            'Action'      => 'CreateKey',
            'Description' => description,
            'KeyUsage'    => usage,
            'Policy'      => policy,
            :parser       => Fog::Parsers::AWS::KMS::DescribeKey.new
          )
        end
      end

      class Mock
        def create_key(policy = nil, description = nil, usage = "ENCRYPT_DECRYPT")
          response = Excon::Response.new
          key_id   = UUID.uuid
          key_arn  = Fog::AWS::Mock.arn("kms", self.account_id, "key/#{key_id}", @region)

          key = {
            "KeyUsage"     => usage,
            "AWSAccountId" => self.account_id,
            "KeyId"        => key_id,
            "Description"  => description,
            "CreationDate" => Time.now,
            "Arn"          => key_arn,
            "Enabled"      => true,
          }

          # @todo use default policy

          self.data[:keys][key_id] = key

          response.body = { "KeyMetadata" => key }
          response
        end
      end
    end
  end
end
