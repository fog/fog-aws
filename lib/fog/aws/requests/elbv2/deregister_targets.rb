module Fog
  module AWS
    class ELBV2
      class Real
        require 'fog/aws/parsers/elbv2/empty'
        # Deregisters the specified targets from the specified target group. After the targets are deregistered, they no longer receive traffic from the load balancer.
        #
        # ==== Parameters
        # * tg_id<~String> - The Amazon Resource Name (ARN) of the target group.
        # * targets<~Array> - List of the targets. If you specified a port override when you registered a target, you must specify both the target ID and the port when you deregister it.
        #   * 'Id'<~String> - The ID of the target.
        #   * 'Port'<~Integer> - The port on which the target is listening.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'ResponseMetadata'<~Hash>:
        #       * 'RequestId'<~String> - Id of request
        def deregister_targets(tg_id, targets)
          params = {}
          target_descriptions = case targets
                                when Hash
                                  targets
                                else
                                  [*targets].map { |id| { 'Id' => id } }
                                end
          params.merge!(Fog::AWS.serialize_keys('Targets', target_descriptions))
          request({
            'Action' => 'DeregisterTargets',
            'TargetGroupArn' => tg_id,
            :parser => Fog::Parsers::AWS::ELBV2::Empty.new
          }.merge(params))
        end
      end

      class Mock
        def deregister_targets(tg_id, targets)
          target_group = self.data[:target_groups][tg_id]
          raise Fog::AWS::ELBV2::NotFound unless target_group

          target_ids = case targets
                        when Hash
                          targets.map { |target| target['Id'] }
                        else
                          [*targets]
                        end

          instance_ids = [*target_ids]
          instance_ids.each do |instance|
            raise Fog::AWS::ELB::InvalidInstance unless Fog::Compute::AWS::Mock.data[@region][@aws_access_key_id][:instances][instance]
          end

          target_group[:targets].delete_if{ |k, v| target_ids.include?(k) }
          target_group[:target_healths].delete_if { |v| target_ids.include?(v['Target']['Id']) }

          response = Excon::Response.new
          response.status = 200

          response.body = {
            'ResponseMetadata' => {
              'RequestId' => Fog::AWS::Mock.request_id
            }
          }
          response
        end
      end
    end
  end
end
