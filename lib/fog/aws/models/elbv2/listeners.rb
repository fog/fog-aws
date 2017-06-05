require 'fog/aws/models/elbv2/listener'

module Fog
  module AWS
    class ELBV2
      class Listeners < Fog::Collection
        model Fog::AWS::ELBV2::Listener

        attr_accessor :data, :load_balancer

        def all
          result = []
          marker = nil
          finished = false
          lb_id = nil
          lb_id = load_balancer.id if load_balancer
          while !finished
            data = service.describe_listeners(lb_id, [], :marker => marker).body
            result.concat(data['DescribeListenersResult']['Listeners'])
            marker = data['DescribeListenersResult']['NextMarker']
            finished = marker.nil?
          end
          load(result) # data is an array of attribute hashes
        end

        def new(attributes={})
          super(attributes.merge(:load_balancer_id => load_balancer.id))
        end

        def get(identity)
          if identity
            resp = service.describe_listeners(nil, identity)
            new(resp.body['DescribeListenersResult']['Listeners'].first)
          end
        rescue Fog::AWS::ELB::NotFound
          nil
        end
      end
    end
  end
end
