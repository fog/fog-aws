module Fog
  module AWS
    class ELBV2
      class Listener < Fog::Model
        identity :id, :aliases => 'ListenerArn'
        attribute :certificates,        :aliases => 'Certificates' # { certificate_arn: ... }
        attribute :default_actions,     :aliases => 'DefaultActions'
        attribute :load_balancer_id,    :aliases => 'LoadBalancerArn'
        attribute :port,                :aliases => 'Port'
        attribute :protocol,            :aliases => 'Protocol' # HTTP, HTTPS
        attribute :ssl_policy,          :aliases => 'SslPolicy'

        attribute :target_group_ids

        def rules
          Fog::AWS::ELBV2::Rules.new(
            :service      => service,
            :listener     => self
          )
        end

        def add_path_rule(path, target_group_id, priority = 1)
          conditions = [{'Field' => 'path-pattern', 'Values' => [path]}]

          add_rule([target_group_id], conditions, :priority => priority)
        end

        def add_host_rule(host, target_group_id, priority = 1)
          conditions = [{'Field' => 'host-header', 'Values' => [host]}]

          add_rule([target_group_id], conditions, :priority => priority)
        end

        def add_rule(tg_ids, conditions, priority = 1)
          actions = tg_ids.map { |tg_id| { 'Type' => 'forward', 'TargetGroupArn' => tg_id } }
          rules.create(
            :actions => actions,
            :conditions => conditions,
            :priority => priority
          )
        end

        def update(attributes)
          requires :id
          merge_attributes(attributes)
          resp = service.modify_listener(id, port, build_default_actions, (protocol && protocol.upcase) || 'HTTP', ssl_policy, build_certificates || [])
          merge_attributes(resp.body['ModifyListenerResult']['Listeners'].first)
        end

        def save
          resp = service.create_listener(load_balancer_id, port, build_default_actions, (protocol && protocol.upcase) || 'HTTP', ssl_policy, build_certificates || [])
          merge_attributes(resp.body['CreateListenerResult']['Listeners'].first)
        end

        def destroy
          requires :id
          service.delete_listener(id)
        end

        protected
          def build_certificates
            certificates.map {|arn| {'CertificateArn' => arn} }
          end

          def build_default_actions
            if target_group_ids && target_group_ids.any?
              target_group_ids.map{ |tg_id| { 'Type' => 'forward', 'TargetGroupArn' => tg_id } }
            else
              default_actions
            end
          end
      end
    end
  end
end
