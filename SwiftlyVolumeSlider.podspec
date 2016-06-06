Pod::Spec.new do |s|
	s.name         = "SwiftlyVolumeSlider"
	s.version      = "0.1"
	s.summary      = "SwiftlyVolumeSlider"
	s.description  = "SwiftlyVolumeSlider - a custom slider control"
	s.homepage     = "https://github.com/maximbilan/SwiftlyVolumeSlider"
	s.license      = { :type => "MIT" }
	s.author       = { "Maxim Bilan" => "maximb.mail@gmail.com" }
	s.platform     = :ios, "8.0"
	s.source       = { :git => "https://github.com/maximbilan/SwiftlyVolumeSlider.git", :tag => "0.1" }
	s.source_files  = "Classes", "SwiftlyVolumeSlider/Sources/**/*.{swift}"
	s.requires_arc = true
end