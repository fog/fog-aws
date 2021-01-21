module Shindo
  class Tests
    def succeeds(&block)
      test('succeeds') do
        !instance_eval(&Proc.new(&block)).nil?
      end
    end
  end
end
