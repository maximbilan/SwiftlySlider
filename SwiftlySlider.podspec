Pod::Spec.new do |s|
	s.name         = "SwiftlySlider"
	s.version      = "0.4"
	s.summary      = "SwiftlySlider"
	s.description  = "SwiftlySlider - a custom slider control"
	s.homepage     = "https://github.com/maximbilan/SwiftlySlider"
	s.license      = { :type => "MIT" }
	s.author       = { "Maxim Bilan" => "maximb.mail@gmail.com" }
	s.platform     = :ios, "8.0"
	s.source       = { :git => "https://github.com/maximbilan/SwiftlySlider.git", :tag => "0.4" }
	s.source_files  = "Classes", "SwiftlySlider/Sources/**/*.{swift}"
	s.requires_arc = true
end