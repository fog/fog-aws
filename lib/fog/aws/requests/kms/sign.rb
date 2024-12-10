module Fog
  module AWS
    class KMS
      class Real
        require 'fog/aws/parsers/kms/sign'

        # Sign
        #
        # ==== Parameters
        #
        # === Returns
        #
        # ==== See Also
        # https://docs.aws.amazon.com/kms/latest/APIReference/API_Sign.html
        def sign(identifier, message, algorithm, options = {})
          request({
            'Action' => 'Sign',
            'KeyId' => identifier,
            'Message' => message,
            'SigningAlgorithm' => algorithm,
            :parser => Fog::Parsers::AWS::KMS::Sign.new
          }.merge!(options))
        end
      end

      class Mock
        def sign(identifier, message, algorithm, _options = {})
          response = Excon::Response.new
          pkey = self.data[:pkeys][identifier]
          unless pkey
            response.status = 404
            raise(Excon::Errors.status_error({ expects: 200 }, response))
          end

          # FIXME: SM2 support?
          sha = "SHA#{algorithm.split('_SHA_').last}"
          hash = OpenSSL::Digest.digest(sha, message)

          signopts = {}
          signopts[:rsa_padding_mode] = 'pss' if algorithm.start_with?('RSASSA_PSS')

          signature = pkey.sign_raw(sha, hash, signopts)

          response.body = {
            'KeyId' => identifier,
            'Signature' => Base64.strict_encode64(signature),
            'SigningAlgorithm' => algorithm
          }
          response
        end
      end
    end
  end
end
