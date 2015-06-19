module Fog
  module AWS
    class Kinesis < Fog::Service
      extend Fog::AWS::CredentialFetcher::ServiceMethods

      requires :aws_access_key_id, :aws_secret_access_key
      recognizes :region, :host, :path, :port, :scheme, :persistent, :use_iam_profile, :aws_session_token, :aws_credentials_expire_at, :instrumentor, :instrumentor_name

      request_path 'fog/aws/requests/kinesis'

      request :list_streams
      request :describe_stream
      request :create_stream
      request :delete_stream
      request :get_shard_iterator
      request :put_records

      class Real
        include Fog::AWS::CredentialFetcher::ConnectionMethods

        def initialize(options={})
          @use_iam_profile = options[:use_iam_profile]

          @connection_options = options[:connection_options] || {}

          @instrumentor           = options[:instrumentor]
          @instrumentor_name      = options[:instrumentor_name] || 'fog.aws.kinesis'

          options[:region] ||= 'us-east-1'
          @region     = options[:region]
          @host       = options[:host] || "kinesis.#{options[:region]}.amazonaws.com"
          @path       = options[:path]        || '/'
          @persistent = options[:persistent]  || false
          @port       = options[:port]        || 443
          @scheme     = options[:scheme]      || 'https'
          @connection = Fog::XML::Connection.new("#{@scheme}://#{@host}:#{@port}#{@path}", @persistent, @connection_options)

          setup_credentials(options)
        end

        private

        def setup_credentials(options)
          @aws_access_key_id      = options[:aws_access_key_id]
          @aws_secret_access_key  = options[:aws_secret_access_key]
          @aws_session_token      = options[:aws_session_token]
          @aws_credentials_expire_at = options[:aws_credentials_expire_at]

          @signer = Fog::AWS::SignatureV4.new( @aws_access_key_id, @aws_secret_access_key, @region, 'kinesis')
        end

        def request(params)
          refresh_credentials_if_expired
          idempotent  = params.delete(:idempotent)
          parser      = params.delete(:parser)

          date = Fog::Time.now
          headers = {
            'X-Amz-Target' => params['X-Amz-Target'],
            'Content-Type' => 'application/x-amz-json-1.1',
            'Host'         => @host,
            'x-amz-date'   => date.to_iso8601_basic
          }
          headers['x-amz-security-token'] = @aws_session_token if @aws_session_token
          body = MultiJson.dump(params[:body])
          headers['Authorization'] = @signer.sign({method: "POST", headers: headers, body: body, query: {}, path: @path}, date)

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
        end

      end

      class Mock
        def initialize(options={})
          raise Fog::Mock::NotImplementedError
        end
      end

    end
  end
end
