Shindo.tests("Storage[:aws] | ListObjectsV2 API", ["aws"]) do

  directory_attributes = {
      :key => uniq_id('foglistobjectsv2tests')
  }

  @directory = Fog::Storage[:aws].directories.create(directory_attributes)

  tests('Direct ListObjectsV2 API usage') do
    
    # Create some test files
    file1 = @directory.files.create(:body => 'test1', :key => 'prefix/file1.txt')
    file2 = @directory.files.create(:body => 'test2', :key => 'prefix/file2.txt')
    file3 = @directory.files.create(:body => 'test3', :key => 'other/file3.txt')
    file4 = @directory.files.create(:body => 'test4', :key => 'file4.txt')

    tests('#list_objects_v2 basic functionality') do
      response = Fog::Storage[:aws].list_objects_v2(@directory.key)
      
      tests('returns proper response structure').returns(true) do
        response.body.has_key?('Contents') && 
        response.body.has_key?('KeyCount') &&
        response.body.has_key?('IsTruncated')
      end

      tests('returns all files').returns(4) do
        response.body['Contents'].size
      end

      tests('has V2-specific KeyCount').returns(4) do
        response.body['KeyCount']
      end
    end

    tests('#list_objects_v2 with parameters') do
      
      tests('with prefix') do
        response = Fog::Storage[:aws].list_objects_v2(@directory.key, 'prefix' => 'prefix/')
        
        tests('filters by prefix').returns(2) do
          response.body['Contents'].size
        end
        
        tests('KeyCount reflects filtered results').returns(2) do
          response.body['KeyCount']
        end
      end

      tests('with max-keys') do
        response = Fog::Storage[:aws].list_objects_v2(@directory.key, 'max-keys' => 2)
        
        tests('limits results').returns(2) do
          response.body['Contents'].size
        end
        
        tests('is truncated').returns(true) do
          response.body['IsTruncated']
        end
        
        tests('has next continuation token').returns(true) do
          !response.body['NextContinuationToken'].nil?
        end
      end

      tests('with start-after') do
        response = Fog::Storage[:aws].list_objects_v2(@directory.key, 'start-after' => 'other/file3.txt')
        
        tests('starts after specified key').returns(true) do
          keys = response.body['Contents'].map { |obj| obj['Key'] }
          keys.none? { |key| key <= 'other/file3.txt' }
        end
      end

      tests('with delimiter') do
        response = Fog::Storage[:aws].list_objects_v2(@directory.key, 'delimiter' => '/')
        
        tests('respects delimiter').returns(true) do
          # Should have common prefixes and fewer direct contents
          response.body.has_key?('CommonPrefixes') && response.body['CommonPrefixes'].size > 0
        end
      end

      tests('with fetch-owner') do
        response = Fog::Storage[:aws].list_objects_v2(@directory.key, 'fetch-owner' => true)
        
        tests('request succeeds').returns(true) do
          response.body.has_key?('Contents')
        end
      end unless Fog.mocking?

    end

    tests('pagination with continuation token') do
      first_page = Fog::Storage[:aws].list_objects_v2(@directory.key, 'max-keys' => 2)
      
      if first_page.body['IsTruncated'] && first_page.body['NextContinuationToken']
        second_page = Fog::Storage[:aws].list_objects_v2(@directory.key, 'continuation-token' => first_page.body['NextContinuationToken'])
        
        tests('second page has different objects').returns(true) do
          first_keys = first_page.body['Contents'].map { |obj| obj['Key'] }
          second_keys = second_page.body['Contents'].map { |obj| obj['Key'] }
          (first_keys & second_keys).empty?
        end
      end
    end

    # Clean up test files
    file1.destroy
    file2.destroy
    file3.destroy
    file4.destroy
  end

  @directory.destroy

end 