# NOTE: Chrome Data's API offers a getModelYears method that returns every year from 1981 through to next year.
#       We could hit the API for that data, but I think that's silly, so this class calculates the years
#       that Chrome Data would return.

module ChromeData
  class ModelYear

    # Chrome Data returns years in the opposite order, but that's not typically
    # how selects are built, so they're reversed here,
    # since that's the only purpose that I can see for this method.
    def self.all
      (Time.now.year + 1).downto(1981).to_a
    end

  end
end