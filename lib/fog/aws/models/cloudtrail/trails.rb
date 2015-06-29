require 'fog/aws/models/cloudtrail/trail'

module Fog
  module AWS
    class CloudTrail
      class Trails < Fog::Collection

        model Fog::AWS::CloudTrail::Trail

        def all
          data = service.describe_trails.body['trailList']
          pdata = data.map{|d| d.merge(:is_persisted => true)} if data
          load(pdata)
        end

        def get(identity)
          data = service.describe_trails('TrailNameList' => identity).body['trailList'].first
          new(data.merge(:is_persisted => true)) unless data.nil?
        end
      end
    end
  end
end