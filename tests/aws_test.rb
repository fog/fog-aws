Shindo.tests('AWS', ['aws']) do
  tests('map keys') do
    simple_hash = {
      :a  => 10,
      :b  => 'str',
      'C' => 1.5
    }
    complex_hash = {
      :x => 100,
      :y => 200,
      :z => [{
              :a => 100,
              :b => 200
             }, {
              :a => 300,
              :b => 400
             }],
      :w => {
        :x => 'str',
        :y => 'str2'
      }
    }
    tests('without mapping and block') {
      returns(complex_hash) { Fog::AWS.map_keys(complex_hash) }
    }

    tests('with block performing changes') {
      result_hash = {
        'A' => 10,
        'B' => 'str',
        'C' => 1.5
      }
      returns(result_hash) { Fog::AWS.map_keys(simple_hash) { |key| key.to_s.upcase } }
    }

    tests('with mapping') {
      result_hash = {
        'AAA' => 10,
        'BB'  => 'str',
        :c    => 1.5
      }
      mapping = {
        :a  => 'AAA',
        :b  => 'BB',
        'C' => :c
      }
      returns(result_hash) { Fog::AWS.map_keys(simple_hash, mapping) }
    }

    tests('with mapping and block') {
      result_hash = {
        'AAA' => 10,
        'B'   => 'str',
        'C'   => 1.5
      }
      mapping = {
        :a => 'AAA'
      }
      returns(result_hash) { Fog::AWS.map_keys(simple_hash, mapping) { |key| key.to_s.upcase } }
    }

    tests('performs nested mapping for hashes and arrays') {
      result_hash = {
        'X' => 100,
        'Y' => 200,
        'Z' => [{
                  'AAA' => 100,
                  :bbb  => 200
                }, {
                  'AAA' => 300,
                  :bbb  => 400
                }],
        'W' => {
          :X => 'str',
          :Y => 'str2'
        }
      }

      mapping = {
        :z => {
          'Z' => {
            :a => 'AAA',
            :b => :bbb
          }
        },
        :w => {
          'W' => {
            :x => :X,
            :y => :Y
          }
        }
      }

      returns(result_hash) { Fog::AWS.map_keys(complex_hash, mapping) { |key| key.to_s.upcase } }
    }
  end

  tests('invert mapping') {
    mapping = {
      'A' => {
        :a => {
          :b => 'B',
          'c' => 'C'
        }
      }
    }

    result = {
      :a => {
        'A' => {
          'B' => :b,
          'C' => 'c'
        }
      }
    }

    returns(result) { Fog::AWS.invert_mappings(mapping) }
  }

  tests('mapping from aws') {
    aws_data = {
      'A' => {
        'B' => {
          'C' => 100,
          'D' => 200
        },
        'E' => [{
                  'FgH' => 300,
                  'IJkl' => 400
                }]
      }
    }

    result = {
      :a => {
        :b => {
          :c => 100,
          :d => 200
        },
        :e => [{
                 :fg_h  => 300,
                 :i_jkl => 400
               }]
      }
    }

    returns(result) { Fog::AWS.map_from_aws(aws_data) }
  }

  tests('mapping to aws') {
    data = {
      :a => {
        :b => {
          :c => 100,
          'd' => 200
        },
        :e => [{
                  'fg_h' => 300,
                  :i_jkl => 400
                }]
      }
    }

    result = {
      'A' => {
        'B' => {
          'C' => 100,
          'D' => 200
        },
        'E' => [{
                  'FgH' => 300,
                  'IJkl' => 400
                }]
      }
    }

    returns(result) { Fog::AWS.map_to_aws(data) }
  }
end