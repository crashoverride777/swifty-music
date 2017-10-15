Pod::Spec.new do |s|

s.name = 'SwiftyMusic'
s.version = '4.1.5'
s.license = 'MIT'
s.summary = 'A swift helper to play music with AVFoundation'
s.homepage = 'https://github.com/crashoverride777/SwiftyMusic'
s.social_media_url = 'http://twitter.com/overrideiactive'
s.authors = { 'Dominik' => 'overrideinteractive@icloud.com' }

s.requires_arc = true
s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4' }

s.ios.deployment_target = '10.3'
#s.tvos.deployment_target = '10.0'

s.source = {
    :git => 'https://github.com/crashoverride777/SwiftyMusic.git',
    :tag => '4.1.5'
}

s.source_files = "SwiftyMusic/**/*.{swift}"

end
