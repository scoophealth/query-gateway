source 'https://rubygems.org'

gem 'rails'
gem 'jruby-openssl', :platforms => :jruby
group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
end

gem 'daemons'
gem 'jquery-rails'

gem 'mongoid'

gem 'delayed_job'
gem 'delayed_job_mongoid'

gem 'hquery-patient-api', :git => 'http://github.com/physiciansdatacollaborative/patientapi.git', :branch => 'master', :tag => 'pdc-0.1.0'
gem "health-data-standards", :git => 'http://github.com/physiciansdatacollaborative/health-data-standards.git', :branch => 'master', :tag => 'pdc-0.1.0'
gem "hqmf2js", :git => 'http://github.com/physiciansdatacollaborative/hqmf2js.git', :branch => 'master', :tag => 'pdc-0.1.0'
gem 'hqmf-parser', :git => 'http://github.com/physiciansdatacollaborative/hqmf-parser.git', :branch => 'master', :tag => 'pdc-0.1.0'

gem 'coderay'

gem 'kramdown'
gem 'pry'

group :test do

  # Pretty printed test output
  gem 'minitest', '< 5.0.0'
  gem 'turn', :require => false
  gem 'cover_me', '>= 1.0.0.rc6', :platforms => :ruby
  gem 'factory_girl'
  gem 'awesome_print', :require => 'ap'
  gem 'mocha', :require => false
  gem 'therubyracer', :platforms => :ruby
  gem 'therubyrhino', :platforms => :jruby

end

#group :production do
#  gem 'thin'
#end
