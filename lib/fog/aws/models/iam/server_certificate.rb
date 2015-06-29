module Fog
  module AWS
    class IAM

      class ServerCertificate < Fog::Model

        identity  :id, :aliases => 'ServerCertificateName'
        attribute :path, :aliases => 'Path'
        attribute :arn, :aliases => 'Arn'
        attribute :server_certificate_id, :aliases => 'ServerCertificateId'

        def destroy
          requires :id
          service.delete_server_certificate(id)
          true
        end

      end

    end
  end
end