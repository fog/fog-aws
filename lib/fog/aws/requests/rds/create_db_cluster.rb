module Fog
  module AWS
    class RDS
      class Real
        require 'fog/aws/parsers/rds/create_db_cluster'

        def create_db_cluster(cluster_name, options={})
          if security_groups = options.delete('VpcSecurityGroups')
            options.merge!(Fog::AWS.indexed_param('VpcSecurityGroupIds.member.%d', [*security_groups]))
          end

          request({
            'Action'              => 'CreateDBCluster',
            'DBClusterIdentifier' => cluster_name,
            :parser               => Fog::Parsers::AWS::RDS::CreateDBCluster.new,
          }.merge(options))
        end
      end

      class Mock
        def create_db_cluster(cluster_name, options={})
          response = Excon::Response.new
          if self.data[:clusters][cluster_name]
            raise Fog::AWS::RDS::IdentifierTaken.new("DBClusterAlreadyExists")
          end

          required_params = %w(Engine MasterUsername MasterUserPassword)
          required_params.each do |key|
            unless options.key?(key) && options[key] && !options[key].to_s.empty?
              raise Fog::AWS::RDS::NotFound.new("The request must contain the parameter #{key}")
            end
          end

          vpc_security_groups = Array(options.delete("VpcSecurityGroups")).map do |group_id|
            {"VpcSecurityGroupId" => group_id }
          end

          data = {
            'AllocatedStorage'           => "1",
            'BackupRetentionPeriod'      => (options["BackupRetentionPeriod"] || 35).to_s,
            'ClusterCreateTime'          => Time.now,
            'DBClusterIdentifier'        => cluster_name,
            'DBClusterMembers'           => [],
            'DBClusterParameterGroup'    => options['DBClusterParameterGroup'] || "default.aurora5.6",
            'DBSubnetGroup'              => options["DBSubnetGroup"] || "default",
            'Endpoint'                   => "#{cluster_name}.cluster-#{Fog::Mock.random_hex(8)}.#{@region}.rds.amazonaws.com",
            'Engine'                     => options["Engine"] || "aurora5.6",
            'EngineVersion'              => options["EngineVersion"] || "5.6.10a",
            'MasterUsername'             => options["MasterUsername"],
            'Port'                       => options["Port"] || "3306",
            'PreferredBackupWindow'      => options["PreferredBackupWindow"] || "04:45-05:15",
            'PreferredMaintenanceWindow' => options["PreferredMaintenanceWindow"] || "sat:05:56-sat:06:26",
            'Status'                     => "available",
            'StorageEncrypted'           => options["StorageEncrypted"] || false,
            'VpcSecurityGroups'          => vpc_security_groups,
          }

          self.data[:clusters][cluster_name] = data
          response.body = {
            "ResponseMetadata" =>      { "RequestId" => Fog::AWS::Mock.request_id },
            "CreateDBClusterResult" => { "DBCluster" => data.dup.reject { |k,v| k == 'ClusterCreateTime' } }
          }
          response.status = 200
          response
        end
      end
    end
  end
end
