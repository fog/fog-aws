module Fog
  module AWS
    class EFS < Fog::Service
      extend Fog::AWS::CredentialFetcher::ServiceMethods

      requires :aws_access_key_id, :aws_secret_access_key
      recognizes :host, :path, :port, :scheme, :persistent, :region, :use_iam_profile, :aws_session_token, :aws_credentials_expire_at, :version, :instrumentor, :instrumentor_name

      request_path 'fog/aws/requests/efs'
      request :create_file_system
      request :describe_file_systems
      request :delete_file_system

      request :create_mount_target
      request :describe_mount_targets
      request :delete_mount_target

      #request :describe_mount_target_security_groups
      #request :modify_mount_target_security_groups

      request :create_tags
      #request :describe_tags
      #request :delete_tags

      class Mock
        def self.data
          @data ||= Hash.new do |hash, region|
            hash[region] = Hash.new do |region_hash, key|
              region_hash[key] = {
                :file_systems  => {},
                :mount_targets => {},
                :tags          => {}
              }
            end
          end
        end

        attr_reader :region
        attr_reader :account_id
        attr_reader :aws_access_key_id

        def initialize(options={})
          @region            = options[:region] || 'us-east-1'
          @aws_access_key_id = options[:aws_access_key_id]
          @account_id        = Fog::AWS::Mock.owner_id
          @module            = "efs"

          unless ['ap-northeast-1', 'ap-southeast-1', 'ap-southeast-2', 'eu-central-1', 'eu-west-1', 'us-east-1', 'us-west-1', 'us-west-2', 'sa-east-1'].include?(@region)
            raise ArgumentError, "Unknown region: #{@region.inspect}"
          end
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
        # Initialize connection to EFS
        #
        # ==== Notes
        # options parameter must include values for :aws_access_key_id and
        # :aws_secret_access_key in order to create a connection
        #
        # ==== Examples
        #   efs = EFS.new(
        #    :aws_access_key_id => your_aws_access_key_id,
        #    :aws_secret_access_key => your_aws_secret_access_key
        #   )
        #
        # ==== Parameters
        # * options<~Hash> - config arguments for connection.  Defaults to {}.
        #
        # ==== Returns
        # * EFS object with connection to AWS.
        def initialize(options={})
          @use_iam_profile    = options[:use_iam_profile]
          @connection_options = options[:connection_options] || {}
          @instrumentor       = options[:instrumentor]
          @instrumentor_name  = options[:instrumentor_name] || 'fog.aws.efs'

          options[:region] ||= 'us-east-1'
          @region = options[:region]
          @host = options[:host] || "elasticfilesystem.#{options[:region]}.amazonaws.com"

          @path       = options[:path]        || '/'
          @persistent = options[:persistent]  || false
          @port       = options[:port]        || 443
          @scheme     = options[:scheme]      || 'https'
          @version    = options[:version]     || '2015-02-01'
          @connection = Fog::Core::Connection.new("#{@scheme}://#{@host}:#{@port}#{@path}", @persistent, @connection_options)

          setup_credentials(options)
        end

        attr_reader :region

        def reload
          @connection.reset
        end

        private

        def setup_credentials(options)
          @aws_access_key_id         = options[:aws_access_key_id]
          @aws_secret_access_key     = options[:aws_secret_access_key]
          @aws_session_token         = options[:aws_session_token]
          @aws_credentials_expire_at = options[:aws_credentials_expire_at]

          @signer = Fog::AWS::SignatureV4.new( @aws_access_key_id, @aws_secret_access_key, @region, 'efs')
        end

        def request(params)
          refresh_credentials_if_expired

          idempotent   = params.delete(:idempotent)
          parser       = params.delete(:parser)
          path         = params.delete(:path)
          request_path = "/#{@version}#{path}"
          query        = params.delete(:query)   || {}
          method       = params.delete(:method)  || 'POST'
          expects      = params.delete(:expects) || 200
          headers      = { 'Content-Type' => 'application/json' }

          headers.merge!(params[:headers] || {})

          #request_path_to_sign = case path
          #when %r{^/functions/([0-9a-zA-Z\:\-\_]+)(/.+)?$}
          #  "/#{@version}/functions/#{Fog::AWS.escape($~[1])}#{$~[2]}"
          #else
          #  request_path
          #end

          body, headers = AWS.signed_params_v4(
            params,
            headers,
            {
              :method            => method,
              :aws_session_token => @aws_session_token,
              :signer            => @signer,
              :host              => @host,
              #:path              => request_path_to_sign,
              :path              => request_path,
              :port              => @port,
              :query             => query,
              :body              => params[:body]
            }
          )

          if @instrumentor
            @instrumentor.instrument("#{@instrumentor_name}.request", params) do
              _request(method, request_path, query, body, headers, expects, idempotent, parser)
            end
          else
            _request(method, request_path, query, body, headers, expects, idempotent, parser)
          end
        end

        def _request(method, path, query, body, headers, expects, idempotent, parser=nil)
          response = process_response(@connection.request({
            :path       => path,
            :query      => query,
            :body       => body,
            :expects    => expects,
            :idempotent => idempotent,
            :headers    => headers,
            :method     => method
          }), parser)
        rescue Excon::Errors::HTTPStatusError => error
          match = Fog::AWS::Errors.match_error(error)
          raise if match.empty?
          raise Fog::AWS::EFS::Error.slurp(error,
            "#{match[:code]} => #{match[:message]}")
        end

        def process_response(response, parser)
          if response &&
             response.body &&
             response.body.is_a?(String) &&
             !response.body.strip.empty? &&
             Fog::AWS.json_response?(response)
            begin
              response.body = Fog::JSON.decode(response.body)
              response.body = parser.process(response.body) if parser
            rescue Fog::JSON::DecodeError => e
              Fog::Logger.warning("Error parsing response json - #{e}")
              response.body = {}
            end
          end
          response
        end
      end
    end
  end
end
