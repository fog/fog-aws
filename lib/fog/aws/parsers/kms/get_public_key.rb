module Fog
  module Parsers
    module AWS
      module KMS
        class GetPublicKey < Fog::Parsers::Base
          def reset
            @response = {}
          end

          def start_element(name, attrs = [])
            super
            case name
            when 'EncryptionAlgorithms', 'KeyAgreementAlgorithms', 'SigningAlgorithms'
              @response[name] = []
            end
          end

          def end_element(name)
            case name
            when 'KeyId', 'KeySpec', 'KeyUsage', 'PublicKey'
              @response[name] = value
            when 'EncryptionAlgorithms', 'KeyAgreementAlgorithms', 'SigningAlgorithms'
              @response[name] << value
            end
          end
        end
      end
    end
  end
end
