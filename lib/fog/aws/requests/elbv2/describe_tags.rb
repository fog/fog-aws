module Fog
  module AWS
    class ELBV2
      class Real
        require 'fog/aws/parsers/elbv2/describe_tags'

        # returns a Hash of tags for a load balancer
        # http://docs.aws.amazon.com/ElasticLoadBalancing/latest/APIReference/API_DescribeTags.html
        # ==== Parameters
        # * resource_arns <~Array> - ARN(s) of the ELB instance whose tags are to be retrieved
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        def describe_tags(resource_arns)
          request({
              'Action' => 'DescribeTags',
              :parser  => Fog::Parsers::AWS::ELBV2::DescribeTags.new
            }.merge!(Fog::AWS.indexed_param('ResourceArns.member.%d', [*resource_arns]))
          )
        end
      end

      class Mock
        def describe_tags(resource_arns)
          response = Excon::Response.new

          if self.data[:load_balancers][resource_arns]
            response.status = 200
            response.body = {"DescribeTagsResult"=>{"LoadBalancers"=>[{"Tags"=>self.data[:tags][resource_arns], "LoadBalancerArn"=>resource_arns}]}}

            response
          else
            raise Fog::AWS::ELBV2::NotFound.new("Elastic load balancer #{resource_arns} not found")
          end
        end

      end
    end
  end
end
