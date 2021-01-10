require 'securerandom'

Shindo.tests('Fog::Storage[:aws] | copy requests', ["aws"]) do

  @directory = Fog::Storage[:aws].directories.create(:key => uniq_id('fogmultipartcopytests'))
  @large_data = SecureRandom.hex * 600000
  @large_blob = Fog::Storage[:aws].put_object(@directory.identity, 'large_object', @large_data)

  tests('copies an empty object') do
    Fog::Storage[:aws].put_object(@directory.identity, 'empty_object', '')

    file = Fog::Storage[:aws].directories.new(key: @directory.identity).files.get('empty_object')
    file.multipart_chunk_size = Fog::AWS::Storage::File::MIN_MULTIPART_CHUNK_SIZE

    tests("#copy_object('#{@directory.identity}', 'empty_copied_object'").succeeds do
      file.copy(@directory.identity, 'empty_copied_object')
    end

    copied = Fog::Storage[:aws].directories.new(key: @directory.identity).files.get('empty_copied_object')
    test("copied is the same") { copied.body == file.body }
  end

  tests('copies a small object') do
    Fog::Storage[:aws].put_object(@directory.identity, 'fog_object', lorem_file)

    file = Fog::Storage[:aws].directories.new(key: @directory.identity).files.get('fog_object')

    tests("#copy_object('#{@directory.identity}', 'copied_object'").succeeds do
      file.copy(@directory.identity, 'copied_object')
    end

    copied = Fog::Storage[:aws].directories.new(key: @directory.identity).files.get('copied_object')
    test("copied is the same") { copied.body == file.body }
  end

  tests('copies a file needing a single part') do
    data = '*' * Fog::AWS::Storage::File::MIN_MULTIPART_CHUNK_SIZE
    Fog::Storage[:aws].put_object(@directory.identity, '1_part_object', data)

    file = Fog::Storage[:aws].directories.new(key: @directory.identity).files.get('1_part_object')
    file.multipart_chunk_size = Fog::AWS::Storage::File::MIN_MULTIPART_CHUNK_SIZE

    tests("#copy_object('#{@directory.identity}', '1_part_copied_object'").succeeds do
      file.copy(@directory.identity, '1_part_copied_object')
    end

    copied = Fog::Storage[:aws].directories.new(key: @directory.identity).files.get('1_part_copied_object')
    test("copied is the same") { copied.body == file.body }
  end

  tests('copies a file with many parts') do
    file = Fog::Storage[:aws].directories.new(key: @directory.identity).files.get('large_object')
    file.multipart_chunk_size = Fog::AWS::Storage::File::MIN_MULTIPART_CHUNK_SIZE

    tests("#copy_object('#{@directory.identity}', 'large_copied_object'").succeeds do
      file.copy(@directory.identity, 'large_copied_object')
    end

    copied = Fog::Storage[:aws].directories.new(key: @directory.identity).files.get('large_copied_object')

    test("concurrency defaults to 1") { file.concurrency == 1 }
    test("copied is the same") { copied.body == file.body }
  end

  tests('copies a file with many parts with 10 threads') do
    file = Fog::Storage[:aws].directories.new(key: @directory.identity).files.get('large_object')
    file.multipart_chunk_size = Fog::AWS::Storage::File::MIN_MULTIPART_CHUNK_SIZE
    file.concurrency = 10

    test("concurrency is set to 10") { file.concurrency == 10 }

    tests("#copy_object('#{@directory.identity}', 'copied_object_with_10_threads'").succeeds do
      file.copy(@directory.identity, 'copied_object_with_10_threads')
    end

    copied = Fog::Storage[:aws].directories.new(key: @directory.identity).files.get('copied_object_with_10_threads')

    test("copied is the same") { copied.body == file.body }
  end

  tests('copies an object with unknown headers') do
    file = Fog::Storage[:aws].directories.new(key: @directory.identity).files.get('large_object')
    file.multipart_chunk_size = Fog::AWS::Storage::File::MIN_MULTIPART_CHUNK_SIZE
    file.concurrency = 10

    tests("#copy_object('#{@directory.identity}', 'copied_object'").succeeds do
      file.copy(@directory.identity, 'copied_object', { unknown: 1 } )
    end

    copied = Fog::Storage[:aws].directories.new(key: @directory.identity).files.get('copied_object')
    test("copied is the same") { copied.body == file.body }
  end
end
