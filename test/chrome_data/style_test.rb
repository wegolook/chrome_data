require_relative '../minitest_helper'

describe ChromeData::Style do
  it 'returns a proper request name' do
    ChromeData::Style.request_name.must_equal 'getStyles'
  end

  describe '.find_all_by_model_id' do
    before do
      ChromeData.configure do |c|
        c.account_number = '123456'
        c.account_secret = '1111111111111111'
      end
    end

    def find_styles
      VCR.use_cassette('wsdl') do
        VCR.use_cassette('2013/divisions/13/models/24997/styles') do
          @models = ChromeData::Style.find_all_by_model_id(24997) # 2013 Ford Mustang
        end
      end
    end

    it 'returns array of Style objects' do
      find_styles

      @models.first.must_be_instance_of ChromeData::Style
      @models.size.must_equal 11
    end

    it 'sets ID on Style objects' do
      find_styles

      @models.first.id.must_equal 349411
    end

    it 'sets name on Style objects' do
      find_styles

      @models.first.name.must_equal '2dr Conv GT'
    end

    it 'caches with proper key' do
      ChromeData.expects(:cache).with('get_styles-model_id-24997')

      find_styles
    end
  end
end
