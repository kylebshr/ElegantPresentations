Pod::Spec.new do |s|

    s.platform = :ios
    s.ios.deployment_target = '8.0'
    s.name = "ElegantPresentations"
    s.summary = "ElegantPresentations: present view controllers with style."
    s.requires_arc = true

    s.version = "1.1.0"

    s.license = { :type => "MIT", :file => "LICENSE" }

    s.author = { "Kyle Bashour" => "kylebshr@me.com" }

    s.homepage = "https://github.com/kylebshr/ElegantPresentations"

    s.source = { :git => "https://github.com/kylebshr/ElegantPresentations.git", :tag => "#{s.version}"}

    s.framework = "UIKit"

    s.source_files = "ElegantPresentations/*.{swift}"
end
