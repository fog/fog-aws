module Fog
  module AWS
    class ELBV2
      class Real
        require 'fog/aws/parsers/elbv2/empty'
        # Removes the specified tags from the specified resource.
        # http://docs.aws.amazon.com/ElasticLoadBalancing/latest/APIReference/API_RemoveTags.html
        #
        # ==== Parameters
        # * resource_id <~String> - The Amazon Resource Name (ARN) of the resource.
        # * keys <~Array> The tag keys for the tags to remove. Array of strings.
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'ResponseMetadata'<~Hash>:
        #       * 'RequestId'<~String> - Id of request
        def remove_tags(resource_id, keys)
          request({
            'Action'=> 'RemoveTags',
            'ResourceArns.member.1' => resource_id,
            :parser => Fog::Parsers::AWS::ELBV2::Empty.new,
          }.merge(Fog::AWS.serialize_keys('TagKeys', keys)))
        end

      end

      class Mock

        def remove_tags(resource_id, keys)
          load_balancer = self.data[:load_balancers][resource_id]
          raise Fog::AWS::ELB::NotFound unless load_balancer

          keys.each {|key| self.data[:tags][resource_id].delete key}

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
