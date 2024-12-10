module Fog
  module AWS
    class KMS
      class Real
        require 'fog/aws/parsers/kms/describe_key'

        # Create Key
        #
        # ==== Parameters
        # * options<~Hash>:
        #   * 'Description'<~String>:
        #   * 'KeyUsage'<~String>:
        #   * 'Policy'<~String>:
        #   * ... (see docs from see also)
        #
        # === Returns
        #
        # ==== See Also
        # https://docs.aws.amazon.com/kms/latest/APIReference/API_CreateKey.html
        def create_key(*args)
          options = Fog::AWS::KMS.parse_create_key_args(args)
          request(
            'Action' => 'CreateKey',
            :parser => Fog::Parsers::AWS::KMS::DescribeKey.new
          ).merge!(options)
        end
      end

      class Mock
        def create_key(*args)
          options = Fog::AWS::KMS.parse_create_key_args(args)

          response = Excon::Response.new
          key_id   = UUID.uuid
          key_arn  = Fog::AWS::Mock.arn("kms", self.account_id, "key/#{key_id}", @region)

          key = {
            'Arn' => key_arn,
            'AWSAccountId' => self.account_id,
            'CreationDate' => Time.now.utc,
            'DeletionDate' => nil,
            'Description' => nil,
            'Enabled' => true,
            'KeyId' => key_id,
            'KeySpec' => 'SYMMETRIC_DEFAULT',
            'KeyState' => 'Enabled',
            'KeyUsage' => 'ENCRYPT_DECRYPT',
            'Policy' => nil
          }.merge!(options)

          # @todo use default policy

          self.data[:keys][key_id] = key

          response.body = { 'KeyMetadata' => key }
          response
        end
      end

      # previous args (policy, description, usage) was deprecated in favor of a hash of options
      def self.parse_create_key_args(args)
        case args.size
        when 0
          {}
        when 1
          if args[0].is_a?(Hash)
            args[0]
          else
            Fog::Logger.deprecation("create_key with distinct arguments is deprecated, use options hash instead [light_black](#{caller.first})[/]")
            {
              'Policy' => args[0]
            }
          end
        when 2, 3
          Fog::Logger.deprecation("create_key with distinct arguments is deprecated, use options hash instead [light_black](#{caller.first})[/]")
          {
            'Policy' => args[0],
            'Description' => args[1],
            'KeyUsage' => args[2] || 'ENCRYPT_DECRYPT'
          }
        else
          raise "Unknown argument style: #{args.inspect}, use options hash instead."
        end
      end
    end
  end
end
