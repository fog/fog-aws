module Fog
  module AWS
    class RDS
      class Real
        require 'fog/aws/parsers/rds/delete_db_cluster_snapshot'

        def delete_db_cluster_snapshot(name)
          request(
            'Action'                      => 'DeleteDBClusterSnapshot',
            'DBClusterSnapshotIdentifier' => name,
            :parser                       => Fog::Parsers::AWS::RDS::DeleteDBClusterSnapshot.new
          )
        end
      end

      class Mock
        def delete_db_cluster_snapshot(name)
          response = Excon::Response.new
          snapshot = self.data[:cluster_snapshots].delete(name)

          raise Fog::AWS::RDS::NotFound.new("DBClusterSnapshotNotFound => #{name} not found") unless snapshot

          response.status = 200
          response.body = {
            "ResponseMetadata"              => {"RequestId"         => Fog::AWS::Mock.request_id},
            "DeleteDBClusterSnapshotResult" => {"DBClusterSnapshot" => snapshot}
          }
          response
        end
      end
    end
  end
end
