module Fog
  module AWS
    module Errors
      def self.match_error(error)
        matcher = lambda {|s| s.match(/(?:.*<Code>(.*)<\/Code>)(?:.*<Message>(.*)<\/Message>)/m)}
        [error.message, error.response.body].each(&Proc.new {|s|
            match = matcher.call(s)
            return {:code => match[1].split('.').last, :message => match[2]} if match
          })
        {} # we did not match the message or response body
      end
    end
  end
end