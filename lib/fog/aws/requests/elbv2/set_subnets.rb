module Fog
  module AWS
    class ELBV2
      class Real
        require 'fog/aws/parsers/elbv2/set_subnets'

        # Enables the Availability Zone for the specified subnets for the specified load balancer. The specified subnets replace the previously enabled subnets.
        #
        # ==== Parameters
        # * lb_id<~String> - The Amazon Resource Name (ARN) of the load balancer.
        # * subnet_ids<~Array> - The IDs of the subnets. You must specify at least two subnets. You can add only one subnet per Availability Zone. Array of strings.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'ResponseMetadata'<~Hash>:
        #       * 'RequestId'<~String> - Id of request
        #     * 'SetSunetsResult'<~Hash>:
        #       * 'AvailabilityZones'<~Hash> - The name of the Availability Zone => The ID of the subnet.
        def set_subnets(lb_id, subnet_ids)
          params = {}

          params.merge!(Fog::AWS.serialize_keys('Subnets', subnet_ids))
          request({
                    'Action'            => 'SetSubnets',
                    'LoadBalancerArn'   => lb_id,
                    :parser             => Fog::Parsers::AWS::ELBV2::SetSubnets.new
                  }.merge!(params))
        end
      end

      class Mock
        def set_subnets(lb_id, subnet_ids)
          load_balancer = self.data[:load_balancers][lb_id]
          raise Fog::AWS::ELBV2::NotFound unless load_balancer
          subnets = Fog::Compute::AWS::Mock.data[region][@aws_access_key_id][:subnets].select {|e| subnet_ids.include?(e["subnetId"]) }

          availability_zones = subnets.inject({}) do |acc, sub|
            if acc[sub['availabilityZone']].nil?
              acc[sub['availabilityZone']] = [sub['subnetId']]
            else
              acc[sub['availabilityZone']] << sub['subnetId']
            end
            acc
          end
          
          load_balancer.merge!('AvailabilityZones' => availability_zones)

          response = Excon::Response.new
          response.status = 200

          response.body = {
            'ResponseMetadata' => {
              'RequestId' => Fog::AWS::Mock.request_id
            },
            'SetSubnetsResult' => {
              'AvailabilityZones' => availability_zones
            }
          }
          response
        end
      end
    end
  end
end
