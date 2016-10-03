Pod::Spec.new do |s|
s.name = 'SwiftyMusic'
s.version = '4.0'
s.summary = 'Music playback with AVFoundation.'
s.description = <<-DESC
A swift singleton class to play music in your project with AVFoundation.'
DESC
s.module_name = "SwiftyMusic"
s.homepage = 'https://github.com/crashoverride777/SwiftyMusic'
s.license = 'MIT'
s.authors = { 'Dominik Ringler' => 'overridegamesuk@icloud.com' }
s.ios.deployment_target = '9.0'
s.source = { :git => 'https://github.com/crashoverride777/SwiftyMusic.git', :tag => s.version }
s.source_files = 'SwiftyMusic/*.{h,swift}'
end
