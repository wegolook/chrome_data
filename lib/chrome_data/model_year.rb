# NOTE: Chrome Data's API offers a getModelYears method that returns every year from 1981 through to next year.
#       We could hit the API for that data, but I think that's silly, so this class calculates the years
#       that Chrome Data would return.

module ChromeData
  class ModelYear
    def self.all
      (1981..Time.now.year + 1).to_a
    end
  end
end