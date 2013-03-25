require_relative '../minitest_helper'

describe ChromeData::ModelYear do
  describe '.all' do
    it 'starts with next year' do
      ChromeData::ModelYear.all.first.must_equal Time.now.year + 1
    end

    it 'ends with 1981' do
      ChromeData::ModelYear.all.last.must_equal 1981
    end
  end
end
