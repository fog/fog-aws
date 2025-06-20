Shindo.tests('Fog::Storage[:aws] | list_objects_v2 requests', ["aws"]) do
  @aws_bucket_name = 'foglistobjectsv2tests-' + Time.now.to_i.to_s(32)

  tests('success') do

    @bucket_v2_format = {
      'CommonPrefixes'        => [],
      'IsTruncated'          => Fog::Boolean,
      'ContinuationToken'    => Fog::Nullable::String,
      'NextContinuationToken' => Fog::Nullable::String,
      'KeyCount'             => Integer,
      'MaxKeys'              => Integer,
      'Name'                 => String,
      'Prefix'               => Fog::Nullable::String,
      'StartAfter'           => Fog::Nullable::String,
      'Contents'             => [{
        'ETag'          => String,
        'Key'           => String,
        'LastModified'  => Time,
        'Owner' => Fog::Nullable::Hash,
        'Size' => Integer,
        'StorageClass' => String
      }]
    }

    tests("#put_bucket('#{@aws_bucket_name}')").succeeds do
      Fog::Storage[:aws].put_bucket(@aws_bucket_name)
    end

    file = Fog::Storage[:aws].directories.get(@aws_bucket_name).files.create(:body => 'y', :key => 'x')

    tests("#list_objects_v2('#{@aws_bucket_name}')").formats(@bucket_v2_format) do
      Fog::Storage[:aws].list_objects_v2(@aws_bucket_name).body
    end

    file.destroy

    file1 = Fog::Storage[:aws].directories.get(@aws_bucket_name).files.create(:body => 'a',    :key => 'a/a1/file1')
    file2 = Fog::Storage[:aws].directories.get(@aws_bucket_name).files.create(:body => 'ab',   :key => 'a/file2')
    file3 = Fog::Storage[:aws].directories.get(@aws_bucket_name).files.create(:body => 'abc',  :key => 'b/file3')
    file4 = Fog::Storage[:aws].directories.get(@aws_bucket_name).files.create(:body => 'abcd', :key => 'file4')

    tests("#list_objects_v2('#{@aws_bucket_name}')") do
      before do
        @bucket = Fog::Storage[:aws].list_objects_v2(@aws_bucket_name)
      end

      tests(".body['Contents'].map{|n| n['Key']}").returns(["a/a1/file1", "a/file2", "b/file3", "file4"]) do
        @bucket.body['Contents'].map{|n| n['Key']}
      end

      tests(".body['Contents'].map{|n| n['Size']}").returns([1, 2, 3, 4]) do
        @bucket.body['Contents'].map{|n| n['Size']}
      end

      tests(".body['CommonPrefixes']").returns([]) do
        @bucket.body['CommonPrefixes']
      end

      tests(".body['KeyCount']").returns(4) do
        @bucket.body['KeyCount']
      end

      tests(".body['IsTruncated']").returns(false) do
        @bucket.body['IsTruncated']
      end
    end

    tests("#list_objects_v2('#{@aws_bucket_name}', 'delimiter' => '/')") do
      before do
        @bucket = Fog::Storage[:aws].list_objects_v2(@aws_bucket_name, 'delimiter' => '/')
      end

      tests(".body['Contents'].map{|n| n['Key']}").returns(['file4']) do
        @bucket.body['Contents'].map{|n| n['Key']}
      end

      tests(".body['CommonPrefixes']").returns(['a/', 'b/']) do
        @bucket.body['CommonPrefixes']
      end

      tests(".body['KeyCount']").returns(3) do
        @bucket.body['KeyCount']
      end
    end

    tests("#list_objects_v2('#{@aws_bucket_name}', 'delimiter' => '/', 'prefix' => 'a/')") do
      before do
        @bucket = Fog::Storage[:aws].list_objects_v2(@aws_bucket_name, 'delimiter' => '/', 'prefix' => 'a/')
      end

      tests(".body['Contents'].map{|n| n['Key']}").returns(['a/file2']) do
        @bucket.body['Contents'].map{|n| n['Key']}
      end

      tests(".body['CommonPrefixes']").returns(['a/a1/']) do
        @bucket.body['CommonPrefixes']
      end

      tests(".body['KeyCount']").returns(2) do
        @bucket.body['KeyCount']
      end
    end

    tests("#list_objects_v2('#{@aws_bucket_name}', 'start-after' => 'a/file2')") do
      before do
        @bucket = Fog::Storage[:aws].list_objects_v2(@aws_bucket_name, 'start-after' => 'a/file2')
      end

      tests(".body['Contents'].map{|n| n['Key']}").returns(['b/file3', 'file4']) do
        @bucket.body['Contents'].map{|n| n['Key']}
      end

      tests(".body['KeyCount']").returns(2) do
        @bucket.body['KeyCount']
      end
    end

    tests("#list_objects_v2('#{@aws_bucket_name}', 'max-keys' => 2)") do
      before do
        @bucket = Fog::Storage[:aws].list_objects_v2(@aws_bucket_name, 'max-keys' => 2)
      end

      tests(".body['Contents'].size").returns(2) do
        @bucket.body['Contents'].size
      end

      tests(".body['KeyCount']").returns(2) do
        @bucket.body['KeyCount']
      end

      tests(".body['IsTruncated']").returns(true) do
        @bucket.body['IsTruncated']
      end

      tests(".body['NextContinuationToken']").returns(true) do
        !@bucket.body['NextContinuationToken'].nil?
      end
    end

    # Test pagination with continuation token
    tests("pagination with continuation token") do
      first_page = Fog::Storage[:aws].list_objects_v2(@aws_bucket_name, 'max-keys' => 2)
      next_token = first_page.body['NextContinuationToken']

      tests("#list_objects_v2 with continuation-token").succeeds do
        second_page = Fog::Storage[:aws].list_objects_v2(@aws_bucket_name, 'continuation-token' => next_token)
        tests("second page has remaining objects").returns(true) do
          second_page.body['Contents'].size > 0
        end
      end if next_token
    end

    # Test fetch-owner parameter
    tests("#list_objects_v2('#{@aws_bucket_name}', 'fetch-owner' => true)") do
      before do
        @bucket = Fog::Storage[:aws].list_objects_v2(@aws_bucket_name, 'fetch-owner' => true)
      end

      tests("owner information is included").returns(true) do
        @bucket.body['Contents'].first['Owner'] != nil
      end
    end unless Fog.mocking?

    tests("#list_objects_v2('#{@aws_bucket_name}', 'fetch-owner' => false)") do
      before do
        @bucket = Fog::Storage[:aws].list_objects_v2(@aws_bucket_name, 'fetch-owner' => false)
      end

      tests("owner information is not included").returns(true) do
        @bucket.body['Contents'].first['Owner'].nil?
      end
    end unless Fog.mocking?

    file1.destroy; file2.destroy; file3.destroy; file4.destroy

    tests("#delete_bucket('#{@aws_bucket_name}')").succeeds do
      Fog::Storage[:aws].delete_bucket(@aws_bucket_name)
    end

  end

  tests('failure') do
    tests("#list_objects_v2('fognonbucket')").raises(Excon::Errors::NotFound) do
      Fog::Storage[:aws].list_objects_v2('fognonbucket')
    end

    tests("#list_objects_v2 without bucket name").raises(ArgumentError) do
      Fog::Storage[:aws].list_objects_v2(nil)
    end
  end

end 