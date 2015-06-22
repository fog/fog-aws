require 'fog/aws'

module Fog
  module AWS
    class CloudTrail < Fog::Service
      extend Fog::AWS::CredentialFetcher::ServiceMethods

      requires :aws_access_key_id, :aws_secret_access_key
      recognizes :region, :host, :path, :port, :scheme, :persistent, :use_iam_profile, :aws_session_token, :aws_credentials_expire_at

      request_path 'fog/aws/requests/cloudtrail'
      request :create_trail
      request :delete_trail
      request :describe_trails
      request :get_trail_status
      request :start_logging
      request :stop_logging
      request :update_trail

      model_path 'fog/aws/models/cloudtrail'
      model :trail
      collection :trails

      class Mock
        def initialize(options={})
          Fog::Mock.not_implemented
        end
      end

      class Real

        include Fog::AWS::CredentialFetcher::ConnectionMethods
        include Fog::AWS::RegionMethods

        # Initialize connection to CloudTrail
        #
        # ==== Notes
        # options parameter must include values for :aws_access_key_id and
        # :aws_secret_access_key in order to create a connection
        #
        # ==== Examples
        #   cloudtrail = CloudTrail.new(
        #    :aws_access_key_id => your_aws_access_key_id,
        #    :aws_secret_access_key => your_aws_secret_access_key
        #   )
        #
        # ==== Parameters
        # * options<~Hash> - config arguments for connection.  Defaults to {}.
        #   * region<~String> - optional region to use. For instance, 'eu-west-1', 'us-east-1' and etc.
        #
        # ==== Returns
        # * CloudTrail object with connection to AWS.

        attr_reader :region

        def initialize(options={})
          @connection_options     = options[:connection_options] || {}
          @region                 = options[:region] ||= 'us-east-1'
          @instrumentor           = options[:instrumentor]
          @instrumentor_name      = options[:instrumentor_name] || 'fog.aws.cloudtrail'
          @version                = options[:version]     ||  '2013-11-01'

          @use_iam_profile = options[:use_iam_profile]
          setup_credentials(options)

          if @endpoint = options[:endpoint]
            endpoint = URI.parse(@endpoint)
            @host = endpoint.host or raise InvalidURIError.new("could not parse endpoint: #{@endpoint}")
            @path = endpoint.path
            @port = endpoint.port
            @scheme = endpoint.scheme
          else
            @host = options[:host] || "cloudtrail.#{options[:region]}.amazonaws.com"
            @path       = options[:path]        || '/'
            @persistent = options[:persistent]  || false
            @port       = options[:port]        || 443
            @scheme     = options[:scheme]      || 'https'
          end

          validate_aws_region(@host, @region)
          @connection = Fog::XML::Connection.new("#{@scheme}://#{@host}:#{@port}#{@path}", @persistent, @connection_options)
        end

        def owner_id
          @owner_id ||= security_groups.get('default').owner_id
        end

        def reload
          @connection.reset
        end

        private

        def setup_credentials(options)
          @aws_access_key_id = options[:aws_access_key_id]
          @aws_secret_access_key = options[:aws_secret_access_key]
          @aws_session_token = options[:aws_session_token]
          @aws_credentials_expire_at = options[:aws_credentials_expire_at]

          @signer = Fog::AWS::SignatureV4.new(@aws_access_key_id, @aws_secret_access_key, @region, 'cloudtrail')
        end

        def request(params)
          refresh_credentials_if_expired
          idempotent  = params.delete(:idempotent)
          parser      = params.delete(:parser)

          body, headers = Fog::AWS.signed_params_v4(
            params,
            {'Content-Type' => 'application/x-www-form-urlencoded'},
            {
              :host               => @host,
              :path               => @path,
              :port               => @port,
              :version            => @version,
              :signer             => @signer,
              :aws_session_token  => @aws_session_token,
              :method             => "POST"
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
                  when 'NotFound', 'Unknown'
                    Fog::Compute::AWS::NotFound.slurp(error, match[:message])
                  else
                    Fog::Compute::AWS::Error.slurp(error, "#{match[:code]} => #{match[:message]}")
                end
        end
      end
    end
  end
end
