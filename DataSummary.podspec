Pod::Spec.new do |s|
  s.name             = 'DataSummary'
  s.version          = '0.1.0'
  s.summary          = 'A simple data summary view.'

  s.description      = <<-DESC
Display data summary in a spreadsheet. Configure the data to a structure in which manner you want it presented.
                       DESC

  s.homepage         = 'https://github.com/olaf.ovrum@gmail.com/DataSummary'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'olaf.ovrum@gmail.com' => 'olaf.ovrum@gmail.com' }
  s.source           = { :git => 'https://github.com/olaf.ovrum@gmail.com/DataSummary.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'DataSummary/Classes/**/*'
end
