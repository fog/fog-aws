class AWS
  class EFS
    module Formats
      CREATE_FILE_SYSTEM = {
        'ownerId'              => String,
        'creationToken'        => String,
        'fileSystemId'         => String,
        'name'                 => Fog::Nullable::String,
        'creationTime'         => Float,
        'lifeCycleState'       => String,
        'numberOfMountTargets' => Integer,
        'sizeInBytes'          => Hash
      }
    end
  end
end
