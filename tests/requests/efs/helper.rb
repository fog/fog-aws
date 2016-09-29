class AWS
  class EFS
    module Formats
      CREATE_FILE_SYSTEM = {
        'OwnerId'              => String,
        'CreationToken'        => String,
        'FileSystemId'         => String,
        'Name'                 => Fog::Nullable::String,
        'CreationTime'         => Float,
        'LifeCycleState'       => String,
        'NumberOfMountTargets' => Integer,
        'SizeInBytes'          => Hash
      }
      DESCRIBE_FILE_SYSTEMS = {
        'FileSystems' => [CREATE_FILE_SYSTEM],
        'Marker'      => Fog::Nullable::String,
        'NextMarker'  => Fog::Nullable::String
      }
      CREATE_MOUNT_TARGET = {
        'MountTargetId'      => String,
        'NetworkInterfaceId' => String,
        'FileSystemId'       => String,
        'LifeCycleState'     => String,
        'SubnetId'           => String,
        'OwnerId'            => String,
        'IpAddress'          => String
      }
      DESCRIBE_MOUNT_TARGETS = {
        'MountTargets' => [CREATE_MOUNT_TARGET],
        'Marker'       => Fog::Nullable::String,
        'NextMarker'   => Fog::Nullable::String
      }
      DESCRIBE_TAGS = {
        'Tags' => [
          {
            'Key'   => String,
            'Value' => String,
          }
        ],
        'Marker'       => Fog::Nullable::String,
        'NextMarker'   => Fog::Nullable::String
      }
      DESCRIBE_MOUNT_TARGET_SECURITY_GROUPS = {
        'SecurityGroups' => Array
      }
    end
  end
end
