Pod::Spec.new do |s|

  s.name         = "ACEViewSwift"
  s.version      = "2.1.0"
  s.summary      = "Use the wonderful ACE editor in your Swift Cocoa applications"

  s.description  = <<-DESC
  The ACEView framework aims to allow you to use the ACE source code editor in your Cocoa applications, as if it were a native control.
  DESC

  s.homepage     = "https://github.com/ACENative/ACEViewSwift"
  s.screenshots  = "https://raw.github.com/ACENative/ACEViewSwift/master/Screenshots/Demo%20window.png"

  s.license      = { :type => "MIT", :file => "LICENSE" }
  
  s.author             = { "Vasilis Akoinoglou" => "alladinian@gmail.com" }
  s.social_media_url   = "http://twitter.com/alladinian"
  
  s.documentation_url = "http://acenative.github.io/ACEViewSwift/"

  s.platform     = :osx, "10.10"

  s.source       = { :git => "https://github.com/ACENative/ACEViewSwift.git", :tag => "v2.1.0", :submodules => true }

  s.source_files  = "ACEViewSwift/*.swift"

  s.framework  = "WebKit"
  
  s.resources = ["ACEBuilds/src-min/*", "ACEViewSwift/Dependencies/emmet/*", "ACEViewSwift/index.html"]

end
