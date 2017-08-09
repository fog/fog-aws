module Fog
  module AWS
    class ELBV2
      class Real
        require 'fog/aws/parsers/elbv2/empty'
        # Adds the specified tags to the specified resource. You can tag your Application Load Balancers and your target groups.
        # http://docs.aws.amazon.com/ElasticLoadBalancing/latest/APIReference/API_AddTags.html
        #
        # ==== Parameters
        # * resource_id <~String> - The Amazon Resource Name (ARN) of the resource.
        # * tags <~Hash> A Hash of (String) key-value pairs
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'ResponseMetadata'<~Hash>:
        #       * 'RequestId'<~String> - Id of request
        def add_tags(resource_id, tags)
          tags_arr = tags.map { |k, v| { 'Key' => k, 'Value' => v } }
          request({
              'Action'                      => 'AddTags',
              'ResourceArns.member.1'       => resource_id,
              :parser                       => Fog::Parsers::AWS::ELBV2::Empty.new,
            }.merge(Fog::AWS.serialize_keys(tags_arr)))
        end

      end

      class Mock

        def add_tags(resource_id, tags)
          self.data[:tags][resource_id].merge! tags

          response = Excon::Response.new
          response.status = 200
          response.body = {
            "ResponseMetadata" => { "RequestId"=> Fog::AWS::Mock.request_id }
          }
          response
        end

      end
    end
  end
end
