module Fog
  module AWS
    class EFS < Fog::Service
      extend Fog::AWS::CredentialFetcher::ServiceMethods

      class FileSystemInUse < Fog::Errors::Error; end

      requires :aws_access_key_id, :aws_secret_access_key

      model_path 'fog/aws/models/efs'
      request_path 'fog/aws/requests/efs'

      model :file_system
      collection :file_systems

      request :create_file_system
      request :delete_file_system
      request :describe_file_systems

      class Mock
        def self.data
          @data ||= Hash.new do |hash, region|
            hash[region] = Hash.new do |region_hash, key|
              region_hash[key] = {
                :file_systems => {}
              }
            end
          end
        end

        def self.reset
          @data = nil
        end

        def data
          self.class.data[@region][@aws_access_key_id]
        end

        def reset
          self.class.reset
        end

        attr_accessor :region

        def initialize(options={})
          @region = options[:region] || "us-east-1"
        end
      end

      class Real
        include Fog::AWS::CredentialFetcher::ConnectionMethods

        def initialize(options={})
          @connection_options = options[:connection_options] || {}
          @instrumentor       = options[:instrumentor]
          @instrumentor_name  = options[:instrumentor_name] || 'fog.aws.efs'

          @region     = 'us-east-1'
          @host       = options[:host]       || "elasticfilesystem.#{@region}.amazonaws.com"
          @port       = options[:port]       || 443
          @scheme     = options[:scheme]     || "https"
          @persistent = options[:persistent] || false
          @connection = Fog::XML::Connection.new("#{@scheme}://#{@host}:#{@port}#{@path}", @persistent, @connection_options)
          @version    = options[:version]    || '2015-02-01'
          @path       = options[:path]       || "/#{@version}/"

          setup_credentials(options)
        end

        def reload
          @connection.reset
        end

        def setup_credentials(options)
          @aws_access_key_id         = options[:aws_access_key_id]
          @aws_secret_access_key     = options[:aws_secret_access_key]
          @aws_session_token         = options[:aws_session_token]
          @aws_credentials_expire_at = options[:aws_credentials_expire_at]

          #global services that have no region are signed with the us-east-1 region
          #the only exception is GovCloud, which requires the region to be explicitly specified as us-gov-west-1
          @signer = Fog::AWS::SignatureV4.new(@aws_access_key_id, @aws_secret_access_key, @region, 'elasticfilesystem')
        end

        def request(params)
          refresh_credentials_if_expired
          idempotent   = params.delete(:idempotent)
          parser       = params.delete(:parser)
          expects      = params.delete(:expects) || 200
          path         = @path + params.delete(:path)
          method       = params.delete(:method) || 'GET'
          request_body = Fog::JSON.encode(params)

          body, headers = Fog::AWS.signed_params_v4(
            params,
            {
              'Content-Type' => "application/x-amz-json-1.0",
            },
            {
              :host               => @host,
              :path               => path,
              :port               => @port,
              :version            => @version,
              :signer             => @signer,
              :aws_session_token  => @aws_session_token,
              :method             => method,
              :body               => request_body
            }
          )

          if @instrumentor
            @instrumentor.instrument("#{@instrumentor_name}.request", params) do
              _request(body, headers, idempotent, parser, method, path, expects)
            end
          else
            _request(body, headers, idempotent, parser, method, path, expects)
          end
        end

        def _request(body, headers, idempotent, parser, method, path, expects)
          response = @connection.request({
            :body       => body,
            :expects    => expects,
            :idempotent => idempotent,
            :headers    => headers,
            :method     => method,
            :parser     => parser,
            :path       => path
          })
          unless response.body.empty?
            response.body = Fog::JSON.decode(response.body)
          end
          response
        rescue Excon::Errors::HTTPStatusError => error
          match = Fog::AWS::Errors.match_error(error)
          raise if match.empty?
          raise case match[:message]
                when /invalid file system id/i
                  Fog::AWS::EFS::NotFound.slurp(error, match[:message])
                else
                  Fog::AWS::EFS::Error.slurp(error, "#{match[:code]} => #{match[:message]}")
                end
        end
      end
    end
  end
end
