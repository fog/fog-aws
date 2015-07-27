require 'fog/aws/models/iam/server_certificate'

module Fog
  module AWS
    class IAM

      class ServerCertificates < Fog::Collection

        model Fog::AWS::IAM::ServerCertificate

        def all(options = {})
          merge_attributes(options)
          data = service.list_server_certificates(options).body
          load(data['Certificates']) # data is an array of attribute hashes
        end

        def get(identity)
          data = service.get_server_certificate(identity).body['Certificate']
          new(data) # data is an attribute hash
        rescue Fog::AWS::IAM::NotFound
          nil
        end

      end
    end
  end
end
