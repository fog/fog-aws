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
    end
  end
end
