Pod::Spec.new do |s|
  s.name = "Comparator"
  s.version = "1.0.0"
  s.summary = "Simple and convenient comparator with multiple conditions powered by Swift."
  s.homepage = "https://github.com/Karetski/Comparator"
  s.author = "Alexey Karetski"
  s.license = { 
    :type => "MIT", 
    :file => "LICENSE.md" 
  }

  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.9"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = "9.0"

  s.source_files  = "Sources/**/*.swift"
  s.source = { 
    :git => "https://github.com/ReactiveCocoa/ReactiveSwift.git",
    :tag => "#{s.version}"
  }

  s.swift_version = "4.1.2"
end