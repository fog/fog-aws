module Fog
  module AWS
    class ELBV2 < Fog::Service
      extend Fog::AWS::CredentialFetcher::ServiceMethods

      API_VERSION = '2015-12-01'

      class IdentifierTaken                 < Fog::Errors::Error; end
      class ResourceInUse                   < Fog::Errors::Error; end
      class InvalidTargetException          < Fog::Errors::Error; end
      class LimitExceeded                   < Fog::Errors::Error; end
      class InvalidConfigurationRequest     < Fog::Errors::Error; end
      class ValidationError                 < Fog::Errors::Error; end
      class ListenerNotFound                < Fog::Errors::Error; end
      class LoadBalancerNotFound            < Fog::Errors::Error; end
      class RuleNotFound                    < Fog::Errors::Error; end
      class PriorityInUse                   < Fog::Errors::Error; end
      class NotPermitted                    < Fog::Errors::Error; end
      class SSLPolicyNotFound               < Fog::Errors::Error; end
      class TargetGroupNotFound             < Fog::Errors::Error; end
      class InvalidTarget                   < Fog::Errors::Error; end
      class TooManyTargets                  < Fog::Errors::Error; end
      class TooManyRegistrationsForTargetId < Fog::Errors::Error; end

      requires :aws_access_key_id, :aws_secret_access_key
      recognizes :region, :host, :path, :port, :scheme, :persistent, :use_iam_profile, :aws_session_token, :aws_credentials_expire_at, :instrumentor, :instrumentor_name

      request_path 'fog/aws/requests/elbv2'
      request :add_tags
      request :create_listener
      request :create_load_balancer
      request :create_rule
      request :create_target_group
      request :delete_listener
      request :delete_load_balancer
      request :delete_rule
      request :delete_target_group
      request :deregister_targets
      request :describe_account_limits
      request :describe_listeners
      request :describe_load_balancer_attributes
      request :describe_load_balancers
      request :describe_rules
      request :describe_ssl_policies
      request :describe_tags
      request :describe_target_group_attributes
      request :describe_target_groups
      request :describe_target_health
      request :modify_listener
      request :modify_load_balancer_attributes
      request :modify_rule
      request :modify_target_group
      request :modify_target_group_attributes
      request :register_targets
      request :remove_tags
      request :set_ip_address_type
      request :set_rule_priorities
      request :set_security_groups
      request :set_subnets

      model_path 'fog/aws/models/elbv2'
      model      :load_balancer
      collection :load_balancers
      model      :target_group
      collection :target_groups
      model      :rule
      collection :rules
      model      :listener
      collection :listeners
      model      :target_health_description
      collection :target_health_descriptions

      class Mock
        require 'fog/aws/elbv2/default_ssl_policies'
        def self.data
          @data ||= Hash.new do |hash, region|
            owner_id = Fog::AWS::Mock.owner_id
            hash[region] = Hash.new do |region_hash, key|
              region_hash[key] = {
                :owner_id => owner_id,

                :tags => {},

                :load_balancers => {},
                :load_balancer_listeners => {},
                :load_balancer_listener_rules => [],

                :target_groups => {},

                :ssl_policies => Fog::AWS::ELBV2::Mock.default_ssl_policies
              }
            end
          end
        end

        def self.dns_name(name, region)
          "#{name}-#{Fog::Mock.random_hex(8)}.#{region}.elb.amazonaws.com"
        end

        def self.reset
          @data = nil
        end

        attr_reader :region

        def initialize(options={})
          @use_iam_profile = options[:use_iam_profile]

          @region = options[:region] || 'us-east-1'
          setup_credentials(options)

          Fog::AWS.validate_region!(@region)
        end

        def setup_credentials(options)
          @aws_access_key_id     = options[:aws_access_key_id]
          @aws_secret_access_key = options[:aws_secret_access_key]

          @signer = Fog::AWS::SignatureV4.new( @aws_access_key_id, @aws_secret_access_key,@region,'elasticloadbalancing')
        end

        def data
          self.class.data[@region][@aws_access_key_id]
        end

        def reset_data
          self.class.data[@region].delete(@aws_access_key_id)
        end
      end

      class Real
        include Fog::AWS::CredentialFetcher::ConnectionMethods
        # Initialize connection to ELB
        #
        # ==== Notes
        # options parameter must include values for :aws_access_key_id and
        # :aws_secret_access_key in order to create a connection
        #
        # ==== Examples
        #   elb = ELB.new(
        #    :aws_access_key_id => your_aws_access_key_id,
        #    :aws_secret_access_key => your_aws_secret_access_key
        #   )
        #
        # ==== Parameters
        # * options<~Hash> - config arguments for connection.  Defaults to {}.
        #   * region<~String> - optional region to use. For instance, 'eu-west-1', 'us-east-1', etc.
        #
        # ==== Returns
        # * ELB object with connection to AWS.
        def initialize(options={})

          @use_iam_profile        = options[:use_iam_profile]
          @connection_options     = options[:connection_options] || {}
          @instrumentor           = options[:instrumentor]
          @instrumentor_name      = options[:instrumentor_name] || 'fog.aws.elb'

          options[:region] ||= 'us-east-1'
          @region     = options[:region]
          @host       = options[:host] || "elasticloadbalancing.#{@region}.amazonaws.com"
          @path       = options[:path]        || '/'
          @persistent = options[:persistent]  || false
          @port       = options[:port]        || 443
          @scheme     = options[:scheme]      || 'https'
          @connection = Fog::XML::Connection.new("#{@scheme}://#{@host}:#{@port}#{@path}", @persistent, @connection_options)

          setup_credentials(options)
        end

        attr_reader :region

        def reload
          @connection.reset
        end

        private

        def setup_credentials(options={})
          @aws_access_key_id         = options[:aws_access_key_id]
          @aws_secret_access_key     = options[:aws_secret_access_key]
          @aws_session_token         = options[:aws_session_token]
          @aws_credentials_expire_at = options[:aws_credentials_expire_at]

          @signer = Fog::AWS::SignatureV4.new(@aws_access_key_id, @aws_secret_access_key, @region, 'elasticloadbalancing')
        end

        def request(params)
          refresh_credentials_if_expired

          idempotent  = params.delete(:idempotent)
          parser      = params.delete(:parser)

          body, headers = Fog::AWS.signed_params_v4(
            params,
            { 'Content-Type' => 'application/x-www-form-urlencoded' },
            {
              :aws_session_token  => @aws_session_token,
              :signer             => @signer,
              :host               => @host,
              :path               => @path,
              :port               => @port,
              :version            => API_VERSION,
              :method             => 'POST'
            }
          )

          if @instrumentor
            @instrumentor.instrument("#{@instrumentor_name}.request", params) do
              _request(body, headers, idempotent, parser)
            end
          else
            _request(body, headers, idempotent, parser)
          end
        end

        def _request(body, headers, idempotent, parser)
          @connection.request({
            :body       => body,
            :expects    => 200,
            :headers    => headers,
            :idempotent => idempotent,
            :method     => 'POST',
            :parser     => parser
          })
        rescue Excon::Errors::HTTPStatusError => error
          match = Fog::AWS::Errors.match_error(error)
          raise if match.empty?
          raise case match[:code]
            when 'OperationNotPermitted'
              Fog::AWS::ELBV2::NotPermitted.slurp(error, match[:message])
            when 'PriorityInUse'
              Fog::AWS::ELBV2::PriorityInUse.slurp(error, match[:message])
            when 'CertificateNotFound'
              Fog::AWS::IAM::NotFound.slurp(error, match[:message])
            when 'LoadBalancerNotFound', 'TargetGroupNotFound', 'SSLPolicyNotFound',
              'CertificateNotFound', 'SubnetNotFound', 'ListenerNotFound', 'RuleNotFound', 'HealthUnavailable'
              Fog::AWS::ELBV2::NotFound.slurp(error, match[:message])
            when 'DuplicateTagKeys', 'DuplicateListener', 'DuplicateLoadBalancerName', 'DuplicateTargetGroupName'
              Fog::AWS::ELBV2::IdentifierTaken.slurp(error, match[:message])
            when 'ResourceInUse'
              Fog::AWS::ELBV2::ResourceInUse.slurp(error, match[:message])
            when 'InvalidTarget'
              Fog::AWS::ELBV2::InvalidTargetException.slurp(error, match[:message])
            when 'InvalidConfigurationRequest'
              Fog::AWS::ELBV2::InvalidConfigurationRequest.slurp(error, match[:message])
            when 'TooManyTags', 'TooManyListeners', 'TooManyCertificates', 'TooManyRegistrationsForTargetId', 'TooManyLoadBalancers', 'TooManyTargetGroups', 'TooManyRules', 'TooManyTargets', 'TargetGroupAssociationLimit',
              Fog::AWS::ELBV2::LimitExceeded.slurp(error, match[:message])
            when 'IncompatibleProtocols', 'InvalidSubnet', 'InvalidSecurityGroup', 'InvalidScheme', 'InvalidTarget', 'UnsupportedProtocol', 'PriorityInUse'
              Fog::AWS::ELB::ValidationError.slurp(error, match[:message])
            else
              Fog::AWS::ELB::Error.slurp(error, "#{match[:code]} => #{match[:message]}")
            end
        end
      end
    end
  end
end
