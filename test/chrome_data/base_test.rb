require_relative '../minitest_helper'

describe ChromeData::Base do
  before do
    ChromeData.remove_class_variable :@@config if ChromeData.class_variable_defined? :@@config
    ChromeData.remove_class_variable :@@cache  if ChromeData.class_variable_defined? :@@cache
  end

  describe '.request' do
    it 'caches request when caching is on' do
       ChromeData.config.cache_store = :memory_store

       ChromeData::Base.expects(:build_request).once.returns stub_everything('request')
       ChromeData::Base.expects(:parse_response).once.returns [mock('element', attributes: { 'id' => mock('id', value: '1') }, text: 'Foo')]
       ChromeData::Base.expects(:make_request).once.returns mock('response')

       first_request = ChromeData::Base.request('modelYear' => 2013)
       second_request = ChromeData::Base.request('modelYear' => 2013)

       first_request.must_equal second_request
    end

    it 'uses appropriate cache key' do
      ChromeData::Base.expects(:cache).with('get_bases-model_year-2013-division_id-5')

      ChromeData::Base.request('modelYear' => 2013, 'divisionId' => 5)
    end

    it 'does not cache request when caching is off' do
       ChromeData::Base.expects(:build_request).twice.returns stub_everything('request')
       ChromeData::Base.expects(:parse_response).twice.returns [stub('element', attributes: { 'id' => stub('id', value: '1') }, text: 'Foo')]
       ChromeData::Base.expects(:make_request).twice.returns mock('response')

       first_request = ChromeData::Base.request('modelYear' => 2013)
       second_request = ChromeData::Base.request('modelYear' => 2013)

       first_request.wont_equal second_request
    end
  end
end
