module Fog
  module AWS
    class ELBV2
      class Real
        require 'fog/aws/parsers/elbv2/empty'
        # Registers the specified targets with the specified target group.
        # By default, the load balancer routes requests to registered targets using the protocol and port number for the target group. Alternatively, you can override the port for a target when you register it.
        # The target must be in the virtual private cloud (VPC) that you specified for the target group. If the target is an EC2 instance, it must be in the running state when you register it.
        #
        # ==== Parameters
        # * tg_id<~String> - The Amazon Resource Name (ARN) of the target group.
        # * target_ids<~Array> - The targets. The default port for a target is the port for the target group.
        # * target_ids_by_port<~Hash> - The targets with non-default ports. Instance ID => port.

        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'ResponseMetadata'<~Hash>:
        #       * 'RequestId'<~String> - Id of request
        def register_targets(tg_id, target_ids = [], target_ids_by_port = {})
          params = {}
          targets = target_ids.map { |id| { 'Id' => id } }
          targets += target_ids_by_port.map { |id, port| { 'Id' => id, 'Port' => port } }
          params.merge!(Fog::AWS.serialize_keys('Targets', targets))
          request({
            'Action' => 'RegisterTargets',
            'TargetGroupArn' => tg_id,
            :parser => Fog::Parsers::AWS::ELBV2::Empty.new
          }.merge(params))
        end
      end

      class Mock
        def register_targets(tg_id, target_ids = [], target_ids_by_port = {})
          target_group = self.data[:target_groups][tg_id]
          raise Fog::AWS::ELBV2::NotFound unless target_group

          target_ids = [*target_ids]
          instance_ids = target_ids_by_port.keys + target_ids
          instance_ids.each do |instance_id|
            raise Fog::AWS::ELB::InvalidInstance unless Fog::Compute::AWS::Mock.data[@region][@aws_access_key_id][:instances][instance_id]
          end

          target_group[:targets] += instance_ids

          # create healthy entries
          instance_ids.each do |instance_id|
            target_group[:target_healths] << {
              'HealthCheckPort' => '80',
              'Target' => { 'Port' => 80, 'Id' => instance_id },
              'TargetHealth' => {
                'State' => 'healthy'
              }
            }
          end

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
