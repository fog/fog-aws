Shindo.tests('AWS::EFS | file system requests', ['aws', 'efs']) do

  efs    = Fog::AWS[:efs]
  account_id = efs.account_id
  region     = efs.region

  tests('success') do

    tests('#create_file_system').formats(AWS::EFS::Formats::CREATE_FILE_SYSTEM) do
      token = Fog::UUID.uuid
      result = efs.create_file_system('CreationToken' => token).body

      returns(true)  { result['creationToken'].eql?(token)                   }
      returns(false) { result['fileSystemId'].match(/^fs-[a-f0-9]{8}$/).nil? }
      returns(true)  { result['lifeCycleState'].eql?('creating')             }
      returns(true)  { result['numberOfMountTargets'].eql?(0)                }
      returns(true)  { result['ownerId'].eql?(account_id)                    }
      returns(true)  { result['sizeInBytes']['value'].eql?(1024)             }

      result
    end

  end

  tests('failures') do

  end

end
