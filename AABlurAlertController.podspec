Pod::Spec.new do |s|
    s.name         = "AABlurAlertController"
    s.version      = "1.0.0"
    s.summary      = "Beautiful configurable Alert View with blurred background"

    s.homepage     = "https://github.com/anas10/AABlurAlertController"
    s.license      = { :type => "MIT", :file => "LICENSE" }

    s.author             = { "Anas AIT ALI" => "contact@aitali.co" }
    s.social_media_url   = "http://twitter.com/anasaitali"

    s.platform     = :ios, "8.0"
    s.requires_arc = true

    s.module_name  = 'AABlurAlertController'
    s.source	 = { :git => "https://github.com/anas10/AABlurAlertController.git", :tag => s.version.to_s }

    s.source_files = 'Source/*.swift'
end
