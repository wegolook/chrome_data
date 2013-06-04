# ChromeData

Provides a simple ruby interface for Chrome Data's API. Read more about it here: http://www.chromedata.com/

The wonderful [lolsoap](https://github.com/loco2/lolsoap) gem does most of the heavy lifting.

## Installation

Add this gem to your application's Gemfile:

    gem 'chrome_data'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install chrome_data

## Usage

### Configuration
Valid options:

  * account_number (required)
  * account_secret (required)
  * country (default: 'US')
  * language (default: 'en')
  * cache_store
  
Configuration:

    ChromeData.config.merge! { account_number: 1234, account_secret: '5678' }
    
### Requests
#### Data Collection
#### Makes (Divisions)  
Fields:

* id (Integer)
* name (String)

Request a set of divisions:

    ChromeData::Division.find_all_by_year(1999)

Request models for a division (same as ChromeData::Model.find_all_by_year_and_division_id)

	mazda = ChromeData::Division.new(id: 26, name: "Mazda")
	mazda_models = mazda.models_for_year(1999)
	
#### Models
Fields:

* id (Integer)
* name (String)

Find models for year and division

	mazda_models = ChromeData::Model.find_all_by_year_and_division_id(1999, 26)
	
Find styles for a specific model (same as ChromeData::Style.find_all_by_model_id)
	
	miata = ChromeData::Model.new(id: 4768, name: "MX-5 Miata") # 1999 Mazda MX-5 Miata
	miata_styles = miata.styles

#### Styles
Fields:

* id (Integer)
* name (String)

Only loaded through a Vehicle:

* trim (String)
* name_without_trim (String)

Find styles for a model by model id

    miata_styles = ChromeData::Style.find_all_by_model_id(4768)
    
#### Vehicle
Fields:

* division (String)
* engines (Array of Engine)
* model (String)
* model_year (Integer)
* styles (Array of Style)

Find a vehicle by VIN

    vehicle = ChromeData::Vehicle.find_by_vin('JM1NB3536X0131402')

#### Engine
Engines are only loaded through a find_by_vin request

Fields:

* type (String)
    
#### Model Years
Years start at 1981 due to VIN standardization

    ChromeData::ModelYears.all

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
