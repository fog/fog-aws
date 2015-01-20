shared_examples "collection" do |collection, params|
  it "should create a new #{collection.model}" do
    collection.new(params)
  end

  context "with a #{collection.model}" do
    before(:all) {
      @resource = collection.create(params)

      if Fog.mocking? && @resource.respond_to?(:ready?)
        @resource.wait_for { ready? }
      end
    }
    subject     { @resource }
    after(:all) { @resource && @resource.destroy }

    it "should #get" do
      expect(
        collection.get(subject.identity).identity
      ).to eq(subject.identity)
    end

    it "should not #get an invalid record" do
      identity = subject.identity.to_s
      identity = identity.gsub(/[a-zA-Z]/) { Fog::Mock.random_letters(1) }
      identity = identity.gsub(/\d/)       { Fog::Mock.random_numbers(1) }

      expect(collection.get(identity)).to be_nil
    end

    context "Enumberable" do
      methods = [
        'all?', 'any?', 'find',  'detect', 'collect', 'map',
        'find_index', 'flat_map', 'collect_concat', 'group_by',
        'none?', 'one?'
      ]

      # JRuby 1.7.5+ issue causes a SystemStackError: stack level too deep
      # https://github.com/jruby/jruby/issues/1265
      if RUBY_PLATFORM == "java" and JRUBY_VERSION =~ /1\.7\.[5-8]/
        methods.delete('all?')
      end

      methods.each do |enum_method|
        if collection.respond_to?(enum_method)
          it "should call ##{enum_method}" do
            skip unless collection.respond_to?(enum_method)
            block_called = false
            collection.send(enum_method) {|x| block_called = true }
            expect(block_called).to eq(true)
          end
        end
      end

      [
        'max_by','min_by'
      ].each do |enum_method|
        it "should call ##{enum_method}" do
          skip unless collection.respond_to?(enum_method)
          block_called = false
          collection.send(enum_method) {|x| block_called = true }
          expect(block_called).to eq(true)
        end
      end
    end
  end
end
