
Pod::Spec.new do |s|

  s.name         = "UtilityFramework"
  s.version      = "1.0.0"
  s.summary      = "This is  UtilityFramework."
  s.description  = <<-DESC
"This is very useful framework . It contains mostly used utilty function"
                   DESC
  s.homepage     = "https://github.com/Sushants278/UtilityFramework.git"
  s.license      = "MIT"
  s.author             = { "Sushant Shinde" => "sushants278@gmail.com" }
  s.platform     = :ios, "11"
  s.source       = { :git => "https://github.com/Sushants278/UtilityFramework.git", :tag => "1.0.0" }
  s.source_files  = "UtilityFramework/**/*"
 s.swift_version = "4.0"

end
