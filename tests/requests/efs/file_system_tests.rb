Shindo.tests('AWS::EFS | file system requests', ['aws', 'efs']) do

  efs    = Fog::AWS[:efs]
  account_id = efs.account_id
  region     = efs.region

  token           = nil
  file_system_id  = nil
  mount_target    = nil
  mount_target_id = nil
  fs_tags         = { 'foo' => 'bar', 'service' => 'wombat', 'v' => '3.1' }

  tests('success') do

    tests('#describe_file_systems').formats(AWS::EFS::Formats::DESCRIBE_FILE_SYSTEMS) do
      result = efs.describe_file_systems.body
      file_systems = result['FileSystems']
      returns(true) { file_systems.empty? }
      result
    end

    tests('#create_file_system').formats(AWS::EFS::Formats::CREATE_FILE_SYSTEM) do
      token = Fog::UUID.uuid
      params = { 'CreationToken' => token }
      result = efs.create_file_system(params).body
      file_system_id = result['FileSystemId']

      returns(true)  { result['CreationToken'].eql?(token)           }
      returns(false) { file_system_id.match(/^fs-[a-f0-9]{8}$/).nil? }
      returns(true)  { result['LifeCycleState'].eql?('creating')     }
      returns(true)  { result['NumberOfMountTargets'].zero?          }
      returns(true)  { result['OwnerId'].eql?(account_id)            }
      returns(true)  { result['SizeInBytes']['Value'] > 0            }

      result
    end

    tests('#describe_file_systems again').formats(AWS::EFS::Formats::DESCRIBE_FILE_SYSTEMS) do
      params = { 'CreationToken' => token }
      result = efs.describe_file_systems(params).body
      file_systems = result['FileSystems']
      fs = file_systems.first

      returns(true) { file_systems.size.eql?(1)               }
      returns(true) { fs['FileSystemId'].eql?(file_system_id) }
      returns(true) { fs['LifeCycleState'].eql?('available')  }
      returns(true) { fs['NumberOfMountTargets'].zero?        }
      returns(true) { fs['OwnerId'].eql?(account_id)          }
      returns(true) { fs['SizeInBytes']['Value'] > 0          }

      result
    end

    tests('#describe_mount_targets').formats(AWS::EFS::Formats::DESCRIBE_MOUNT_TARGETS) do
      params = { 'FileSystemId' => file_system_id }
      result = efs.describe_mount_targets(params).body
      mount_targets = result['MountTargets']
      returns(true) { mount_targets.empty? }
      result
    end

    tests('#create_mount_target').formats(AWS::EFS::Formats::CREATE_MOUNT_TARGET) do
      subnet_id = Fog::AWS::Mock.subnet_id
      params = {
        'FileSystemId'   => file_system_id,
        'SubnetId'       => subnet_id,
        'SecurityGroups' => Fog::AWS::Mock.security_group_id
      }

      result = efs.create_mount_target(params).body
      mount_target = result
      mount_target_id = result['MountTargetId']
      network_interface_id = result['NetworkInterfaceId']

      returns(true)  { result['FileSystemId'].eql?(file_system_id)          }
      returns(true)  { result['LifeCycleState'].eql?('creating')            }
      returns(false) { mount_target_id.match(/^fsmt-[0-9a-f]{8}$/).nil?     }
      returns(false) { network_interface_id.match(/^eni-[0-9a-f]{8}$/).nil? }
      returns(true)  { result['OwnerId'].eql?(account_id)                   }
      returns(true)  { result['SubnetId'].eql?(subnet_id)                   }

      result
    end

    tests('#describe_file_systems after mount target creation').formats(AWS::EFS::Formats::DESCRIBE_FILE_SYSTEMS) do
      params = { 'CreationToken' => token }
      result = efs.describe_file_systems(params).body
      file_systems = result['FileSystems']
      fs = file_systems.first

      returns(false) { fs['NumberOfMountTargets'].zero?   }
      returns(true)  { fs['NumberOfMountTargets'].eql?(1) }

      result
    end

    tests('#describe_mount_targets again').formats(AWS::EFS::Formats::DESCRIBE_MOUNT_TARGETS) do
      params = { 'FileSystemId' => file_system_id }
      result = efs.describe_mount_targets(params).body
      mount_targets = result['MountTargets']
      mt = mount_targets.first

      returns(false) { mount_targets.empty?                            }
      returns(true)  { mt['FileSystemId'].eql?(file_system_id)         }
      returns(true)  { mt['IpAddress'].eql?(mount_target['IpAddress']) }
      returns(true)  { mt['LifeCycleState'].eql?('available')          }
      returns(true)  { mt['MountTargetId'].eql?(mount_target_id)       }
      returns(true)  { mt['NetworkInterfaceId'].eql?(mount_target['NetworkInterfaceId']) }
      returns(true)  { mt['OwnerId'].eql?(account_id)                  }
      returns(true)  { mt['SubnetId'].eql?(mount_target['SubnetId'])   }

      result
    end

    tests('#delete_mount_target') do
      params = { 'MountTargetId' => mount_target_id }
      result = efs.delete_mount_target(params).body
      returns(true) { result.empty? }
      result
    end

    tests('#describe_file_systems after mount target deletion').formats(AWS::EFS::Formats::DESCRIBE_FILE_SYSTEMS) do
      params = { 'CreationToken' => token }
      result = efs.describe_file_systems(params).body
      file_systems = result['FileSystems']
      fs = file_systems.first

      returns(true) { fs['NumberOfMountTargets'].zero? }

      result
    end

    tests('#create_tags') do
      params = {
        'FileSystemId' => file_system_id,
        'Tags'         => fs_tags
      }
      result = efs.create_tags(params)
      returns(true) { result.body.empty?      }
      returns(true) { result.status.eql?(204) }
      result
    end

    tests('#describe_tags').formats(AWS::EFS::Formats::DESCRIBE_TAGS) do
      params = { 'FileSystemId' => file_system_id }
      result = efs.describe_tags(params).body
      tags = result['Tags']

      returns(false) { tags.empty? }
      returns(true)  { tags.size > 1 }

      tags.each do |t|
        returns(true) { t.keys.size.eql?(2) }
        t.keys.each do |key|
          returns(true) { key.eql?('Key') || key.eql?('Value') }
        end
      end

      result
    end

    tests('#delete_tags') do
      params = {
        'FileSystemId' => file_system_id,
        'TagKeys'      => fs_tags.keys.shuffle.first
      }
      result = efs.delete_tags(params)
      returns(true)  { result.body.empty? }
      returns(true)  { result.status.eql?(204) }
      result
    end

    tests('#describe_tags again').formats(AWS::EFS::Formats::DESCRIBE_TAGS) do
      params = { 'FileSystemId' => file_system_id }
      result = efs.describe_tags(params).body
      tags = result['Tags']

      returns(false) { tags.empty? }
      returns(true)  { tags.size < fs_tags.size }

      result
    end

    tests('#delete_file_system') do
      params = { 'FileSystemId' => file_system_id }
      result = efs.delete_file_system(params).body
      returns(true)  { result.empty? }
      result
    end

  end

  tests('failures') do

  end

end
