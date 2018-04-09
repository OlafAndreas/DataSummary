Pod::Spec.new do |s|
  s.name             = 'DataSummary'
  s.version          = '1.0.2'
  s.summary          = 'A simple data summary view.'

  s.description      = <<-DESC
Display data summary in a spreadsheet. Configure the data to a structure in which manner you want it presented.
                       DESC

  s.homepage         = 'https://github.com/huconglobal/DataSummary'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'olaf.ovrum@gmail.com' => 'olaf.ovrum@gmail.com' }
  s.source           = { :git => 'https://github.com/huconglobal/DataSummary.git', :tag => s.version.to_s }
  
  s.swift_version = '4.1'
  s.ios.deployment_target = '9.0'

  s.source_files = 'DataSummary/Classes/**/*'
end
