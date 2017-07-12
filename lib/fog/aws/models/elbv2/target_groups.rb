require 'fog/aws/models/elb/load_balancer'

module Fog
  module AWS
    class ELBV2
      class TargetGroups < Fog::Collection
        model Fog::AWS::ELBV2::TargetGroup

        attr_accessor :load_balancer

        def all
          result = []
          marker = nil
          finished = false
          lb_id = nil
          lb_id = load_balancer.id if load_balancer

          while !finished
            data = service.describe_target_groups(lb_id, [], :marker => marker).body
            result.concat(data['DescribeTargetGroupsResult']['TargetGroups'])
            marker = data['DescribeTargetGroupsResult']['NextMarker']
            finished = marker.nil?
          end
          load(result) # data is an array of attribute hashes
        end

        def get(identity)
          if identity
            resp = service.describe_target_groups(nil, identity)
            new(resp.body['DescribeTargetGroupsResult']['TargetGroups'].first)
          end
        rescue Fog::AWS::ELBV2::TargetGroupNotFound
          nil
        end
      end
    end
  end
end
