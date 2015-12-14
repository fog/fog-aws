module Fog
  module AWS
    class RDS
      class Real
        require 'fog/aws/parsers/rds/delete_db_cluster'

        def delete_db_cluster(identifier, snapshot_identifier, skip_snapshot = false)
          params = {}
          params["FinalDBSnapshotIdentifier"] = snapshot_identifier if snapshot_identifier
          request({
            'Action'              => 'DeleteDBCluster',
            'DBClusterIdentifier' => identifier,
            'SkipFinalSnapshot'   => skip_snapshot,
          }.merge(params))
        end
      end

      class Mock
        def delete_db_cluster(identifier, snapshot_identifier, skip_snapshot = false)
          response = Excon::Response.new

          cluster = self.data[:clusters][identifier] || raise(Fog::AWS::RDS::NotFound.new("DBCluster #{identifier} not found"))

          raise Fog::AWS::RDS::Error.new("InvalidDBClusterStateFault => Cluster cannot be deleted, it still contains DB instances in non-deleting state.") if cluster["DBClusterMembers"].any?

          unless skip_snapshot
            create_db_cluster_snapshot(identifier, snapshot_identifier)
          end

          self.data[:clusters].delete(identifier)

          response.status = 200
          response.body   = {
            "ResponseMetadata"      => { "RequestId" => Fog::AWS::Mock.request_id },
            "DeleteDBClusterResult" => { "DBCluster" => cluster}
          }
          response
        end
      end
    end
  end
end
