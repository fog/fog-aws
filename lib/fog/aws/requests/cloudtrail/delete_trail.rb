module Fog
  module AWS
    class CloudTrail


      class Real
        require 'fog/aws/parsers/cloudtrail/delete_trail'

        def delete_trail(name)
          request({
              'Action' => 'DeleteTrail',
              'Name' => name,
              :parser => Fog::Parsers::CloudTrail::AWS::DeleteTrail.new
            })
        end
      end


      class Mock
        def delete_trail(name)
          Fog::Mock.not_implemented
        end
      end

    end
  end
end
