module Fog
  module AWS
    class ELBV2
      class Real
        require 'fog/aws/parsers/elbv2/describe_tags'

        # Describes the tags for the specified resources. You can describe the tags for one or more Application Load Balancers and target groups.
        #
        # http://docs.aws.amazon.com/ElasticLoadBalancing/latest/APIReference/API_DescribeTags.html
        #
        # ==== Parameters
        # * lb_ids <~String> -The Amazon Resource Names (ARN) of the resources.
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'ResponseMetadata'<~Hash>:
        #       * 'RequestId'<~String> - Id of request
        #     * 'DescribeTagsResult'<~Hash>:
        #       * 'TagDescriptions'<~Array>:
        #         * 'ResourceArn'<~String> - The Amazon Resource Name (ARN) of the resource.
        #         * 'Tags'<~Hash> - Information about tags in key value form.
        def describe_tags(lb_ids)
          lb_ids = [*lb_ids]
          request({
              'Action' => 'DescribeTags',
              :parser  => Fog::Parsers::AWS::ELBV2::DescribeTags.new
            }.merge(Fog::AWS.serialize_keys('ResourceArns', lb_ids))
          )
        end
      end

      class Mock

        def describe_tags(lb_id)
          raise Fog::AWS::ELBV2::NotFound unless self.data[:load_balancers][lb_id]

          response = Excon::Response.new
          response.status = 200
          response.body = {
            "DescribeTagsResult" => {
              "TagDescriptions"=>[
                {
                  "Tags" => self.data[:tags][lb_id],
                  "ResourceArn" => lb_id
                }
              ]
            }
          }
          response
        end

      end
    end
  end
end
