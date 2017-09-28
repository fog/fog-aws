require 'fog/aws/models/elbv2/load_balancer'

module Fog
  module AWS
    class ELBV2
      class LoadBalancers < Fog::Collection
        model Fog::AWS::ELBV2::LoadBalancer

        # Creates a new load balancer
        def initialize(attributes={})
          super
        end

        def all
          result = []
          marker = nil
          finished = false
          until finished
            data = service.describe_load_balancers(nil, :marker => marker).body
            result.concat(data['DescribeLoadBalancersResult']['LoadBalancers'])
            marker = data['DescribeLoadBalancersResult']['NextMarker']
            finished = marker.nil?
          end
          load(result) # data is an array of attribute hashes
        end

        def get(identity)
          if identity
            resp = service.describe_load_balancers(identity)
            new(resp.body['DescribeLoadBalancersResult']['LoadBalancers'].first)
          end
        rescue Fog::AWS::ELBV2::NotFound
          nil
        end
      end
    end
  end
end
