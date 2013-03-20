require_relative '../minitest_helper'

describe ChromeData::Model do
  it 'returns a proper request name' do
    ChromeData::Model.request_name.must_equal 'getModels'
  end

  describe '.find_all_by_year_and_division_id' do
    before do
      ChromeData.configure do |c|
        c.account_number = '123456'
        c.account_secret = '1111111111111111'
      end

      VCR.use_cassette('wsdl') do
        VCR.use_cassette('2013/divisions/13/models') do
          @models = ChromeData::Model.find_all_by_year_and_division_id(2013, 13) # 2013 Fords
        end
      end
    end

    it 'returns array of Model objects' do
      @models.first.must_be_instance_of ChromeData::Model
      @models.size.must_equal 39
    end

    it 'sets ID on Model objects' do
      @models.first.id.must_equal 25459
    end

    it 'sets name on Model objects' do
      @models.first.name.must_equal 'C-Max Energi'
    end
  end

  describe '#styles' do
    it 'finds styles for Model' do
      ChromeData::Style.expects(:find_all_by_model_id).with(24997)

      ChromeData::Model.new(id: 24997, name: 'Mustang').styles
    end
  end
end
