module Fog
  module AWS
    class KMS
      class Real
        require 'fog/aws/parsers/kms/get_public_key'

        def get_public_key(identifier, grant_tokens = nil)
          request(
            'Action' => 'GetPublicKey',
            'GrantTokens' => grant_tokens,
            'KeyId' => identifier,
            :parser => Fog::Parsers::AWS::KMS::GetPublicKey.new
          )
        end
      end

      class Mock
        def get_public_key(identifier, _grant_tokens = [])
          response = Excon::Response.new
          key = self.data[:keys][identifier]
          pkey = self.data[:pkeys][identifier]

          response.body = {
            'KeyId' => key['Arn'],
            'KeyUsage' => key['KeyUsage'],
            'KeySpec' => key['KeySpec'],
            'PublicKey' => Base64.strict_encode64(pkey.public_to_der),
            'SigningAlgorithms' => key['SigningAlgorithms']
          }
          response
        end
      end
    end
  end
end
