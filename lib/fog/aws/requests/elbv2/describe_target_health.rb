module Fog
  module AWS
    class ELBV2
      class Real
        require 'fog/aws/parsers/elbv2/describe_target_health'

        # Describes the health of the specified targets or all of your targets.
        # http://docs.aws.amazon.com/elasticloadbalancing/latest/APIReference/API_TargetHealth.html
        #
        # ==== Parameters
        # * tg_id<~String> - The Amazon Resource Name (ARN) of the target group.
        # * target_ids<~Array> - The targets.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'ResponseMetadata'<~Hash>:
        #       * 'RequestId'<~String> - Id of request
        #     * 'DescribeTargetHealthResult'<~Hash>:
        #       * 'TargetHealthDescriptions'<~Array>:
        #         * 'HealthCheckPort'<~String> - The port to use to connect with the target.
        #         * 'Target'<~Hash>:
        #           * 'Id'<~String> - The ID of the target.
        #           * 'Port'<~Integer> - The port on which the target is listening.
        #         * 'TargetHealth'<~Hash>:
        #           * 'State'<~String> - The state of the target.
        #           * 'Description'<~String> - A description of the target health that provides additional details. If the state is healthy, a description is not provided.
        #           * 'Reason'<~String> - The reason code. If the target state is healthy, a reason code is not provided.
        def describe_target_health(tg_id, target_ids = [])
          params = {}
          params.merge!(Fog::AWS.serialize_keys('Targets', target_ids)) if target_ids.any?
          request({
            'Action' => 'DescribeTargetHealth',
            'TargetGroupArn' => tg_id,
            :parser => Fog::Parsers::AWS::ELBV2::DescribeTargetHealth.new
          }.merge(params))
        end
      end

      class Mock
        def describe_target_health(tg_id, target_ids = [])
          target_group = self.data[:target_groups][tg_id]
          raise Fog::AWS::ELBV2::NotFound unless target_group

          target_healths = target_group[:target_healths]
          target_healths = target_healths.select { |health| target_ids.include?(health['Target']['Id']) } if target_ids.any?

          response = Excon::Response.new
          response.status = 200

          response.body = {
            'ResponseMetadata' => {
              'RequestId' => Fog::AWS::Mock.request_id
            },
            'DescribeTargetHealthResult' => {
              'TargetHealthDescriptions' => target_healths
            }
          }
          response
        end
      end
    end
  end
end
