module Fog
  module AWS
    class RDS
      class Real
        require 'fog/aws/parsers/rds/describe_engine_default_parameters'

        def describe_engine_default_parameters(family, opts={})
          request({
            'Action'                 => 'DescribeEngineDefaultParameters',
            'DBParameterGroupFamily' => family,
            :parser                  => Fog::Parsers::AWS::RDS::DescribeEngineDefaultParameters.new,
          }.merge(opts))
        end
      end

      class Mock
        def describe_engine_default_parameters(family, opts={})
          response = Excon::Response.new

          response.status = 200
          response.body   = {
            "ResponseMetadata"                      => { "RequestId"  => Fog::AWS::Mock.request_id },
            "DescribeEngineDefaultParametersResult" => { "Parameters" => self.data[:default_parameters][family]}
          }
          response
        end
      end
    end
  end
end
