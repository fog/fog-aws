module Fog
  module AWS
    class ELBV2
      class Real
        require 'fog/aws/parsers/elbv2/empty'
        # Deletes the specified target group.
        #
        # You can delete a target group if it is not referenced by any actions. Deleting a target group also deletes any associated health checks.
        #
        # ==== Parameters
        # * tg_id<~String> - The Amazon Resource Name (ARN) of the target group.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'ResponseMetadata'<~Hash>:
        #       * 'RequestId'<~String> - Id of request
        def delete_target_group(tg_id)
          request({
            'Action'          => 'DeleteTargetGroup',
            'TargetGroupArn'  => tg_id,
            :parser           => Fog::Parsers::AWS::ELBV2::Empty.new
          })
        end
      end

      class Mock
        def delete_target_group(tg_id)
          raise Fog::AWS::ELBV2::NotFound unless self.data[:target_groups].delete(tg_id)

          response = Excon::Response.new
          response.status = 200

          response.body = {
            'ResponseMetadata' => {
              'RequestId' => Fog::AWS::Mock.request_id
            },
            'DeleteTargetGroupResult' => nil
          }

          response
        end
      end
    end
  end
end
