require 'fog/aws/models/rds/server'

module Fog
  module AWS
    class RDS
      class Servers < Fog::Collection
        model Fog::AWS::RDS::Server

        def all
          data = service.describe_db_instances.body['DescribeDBInstancesResult']['DBInstances']
          load(data) # data is an array of attribute hashes
        end

        def get(identity)
          data = service.describe_db_instances(identity).body['DescribeDBInstancesResult']['DBInstances'].first
          new(data) # data is an attribute hash
        rescue Fog::AWS::RDS::NotFound
          nil
        end

        def restore(snapshot_id, db_name, options={})
          create(options.merge('source_snapshot_id' => snapshot_id, 'id' => db_name))
        end
      end
    end
  end
end
