class AWS
  module EFS
    module Formats
      FILE_SYSTEM_FORMAT = {
        "CreationTime"         => Float,
        "CreationToken"        => String,
        "FileSystemId"         => String,
        "LifeCycleState"       => String,
        "Name"                 => Fog::Nullable::String,
        "NumberOfMountTargets" => Integer,
        "OwnerId"              => String,
        "PerformanceMode"      => String,
        "SizeInBytes"          => {
          "Timestamp" => Fog::Nullable::Float,
          "Value"     => Integer
        }
      }

      DESCRIBE_FILE_SYSTEMS_RESULT = {
        "FileSystems" => [FILE_SYSTEM_FORMAT]
      }
    end
  end
end
