Shindo.tests('AWS::EFS | file system requests', ['aws', 'efs']) do

  efs    = Fog::AWS[:efs]
  account_id = efs.account_id
  region     = efs.region

  token = nil
  file_system_id = nil

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
