module Fog
  module AWS
    class RDS
      class Real
        require 'fog/aws/parsers/rds/restore_db_instance_to_point_in_time'

        # Restores a DB Instance to a point in time
        # http://docs.amazonwebservices.com/AmazonRDS/latest/APIReference/index.html?API_RestoreDBInstanceToPointInTime.html
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        def restore_db_instance_to_point_in_time(source_db_name, target_db_name, opts={})
          request({
            'Action'  => 'RestoreDBInstanceToPointInTime',
            'SourceDBInstanceIdentifier' => source_db_name,
            'TargetDBInstanceIdentifier' => target_db_name,
            :parser   => Fog::Parsers::AWS::RDS::RestoreDBInstanceToPointInTime.new,
          }.merge(opts))
        end
      end

      class Mock
        def restore_db_instance_to_point_in_time(source_db_name, target_db_name, opts={})
          response = Excon::Response.new

          # check for some restore specific attributes
          if self.data[:servers] and self.data[:servers][target_db_name]
            raise Fog::AWS::RDS::IdentifierTaken.new("DBInstanceAlreadyExists #{response.body.to_s}")
          end

          data = {
            "AllocatedStorage"                 => opts['AllocatedStorage'] || 100,
            "AutoMinorVersionUpgrade"          => opts['AutoMinorVersionUpgrade'].nil? ? true : opts['AutoMinorVersionUpgrade'],
            "AvailabilityZone"                 => opts['AvailabilityZone'] || 'us-east-1a',
            "BackupRetentionPeriod"            => opts['BackupRetentionPeriod'] || 1,
            "CACertificateIdentifier"          => 'rds-ca-2015',
            "DBInstanceClass"                  => opts['DBInstanceClass'] || 'db.m3.medium',
            "DBInstanceIdentifier"             => target_db_name,
            "DBInstanceStatus"                 => 'creating',
            "DBName"                           => opts['DBName'],
            "DBParameterGroups"                => [{'DBParameterGroupName'=>'default.mysql5.6', 'ParameterApplyStatus'=>'in-sync'}],
            "DBSecurityGroups"                 => [{'Status'=>'active', 'DBSecurityGroupName'=>'default'}],
            "Endpoint"                         => {},
            "Engine"                           => opts['Engine'] || 'mysql',
            "EngineVersion"                    => opts['EngineVersion'] || '5.5.6',
            "InstanceCreateTime"               => nil,
            "Iops"                             => opts['Iops'],
            "LicenseModel"                     => 'general-public-license',
            "MasterUsername"                   => 'username',
            "MultiAZ"                          => !!opts['MultiAZ'],
            "OptionGroupMemberships"           => [{ 'OptionGroupMembership' => [{ 'OptionGroupName' => 'default: mysql-5.6', 'Status' => "pending-apply"}] }],
            "PreferredBackupWindow"            => '08:00-08:30',
            "PreferredMaintenanceWindow"       => 'mon:04:30-mon:05:00',
            "PubliclyAccessible"               => true,
            "ReadReplicaDBInstanceIdentifiers" => [],
            "StorageType"                      => opts['StorageType'] || (opts['Iops'] ? 'io1' : 'standard'),
            "VpcSecurityGroups"                => nil,
            "StorageEncrypted"                 => false,
          }

          self.data[:servers][target_db_name] = data
          response.body =
            { "ResponseMetadata" => { "RequestId" => Fog::AWS::Mock.request_id },
              "RestoreDBInstanceToPointInTimeResult" => { "DBInstance" => data }
          }
          response.status = 200
          self.data[:servers][target_db_name]["InstanceCreateTime"] = Time.now
          response
        end
      end
    end
  end
end
