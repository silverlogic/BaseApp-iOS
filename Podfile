source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
inhibit_all_warnings!

target 'Development' do
    use_frameworks!
    
    pod 'AlamofireActivityLogger', '~> 2.4.0'
    pod 'AlamofireNetworkActivityIndicator', '~> 2.0'
    pod 'Branch'
    pod 'CCBottomRefreshControl'
    pod 'Crashlytics', '~> 3.8'
    pod 'Dodo', '~> 9.0.1'
    pod 'ImagePicker', '~> 3.0.0'
    pod 'IQKeyboardManager'
    pod 'KeychainAccess', '~> 3.1.0'
    pod 'Kingfisher', '~> 4.1.0'
    pod 'KYNavigationProgress', '~> 2.0.2'
    pod 'Onboard'
    pod 'PopupDialog', '~> 0.6.0'
    pod 'Raccoon', '~> 1.2.0'
    pod 'SCLAlertView', '0.7.0'
    pod 'SVProgressHUD'
    pod 'SwiftyBeaver'
    pod 'SwiftLint'
    pod 'UITextField+Shake', '~> 1.1'
    
    target 'Staging' do
    end
    
    target 'Production' do
    end
    
    target 'UnitTests' do
        inherit! :search_paths
        pod 'OHHTTPStubs', :git => 'https://github.com/eman6576/OHHTTPStubs'
        pod 'OHHTTPStubs/Swift', :git => 'https://github.com/eman6576/OHHTTPStubs'
    end
    
    target 'IntegrationTests' do
        inherit! :search_paths
        pod 'OHHTTPStubs', :git => 'https://github.com/eman6576/OHHTTPStubs'
        pod 'OHHTTPStubs/Swift', :git => 'https://github.com/eman6576/OHHTTPStubs'
        pod 'KIF'
    end
    
    target 'UITests' do
        inherit! :search_paths
        pod 'OHHTTPStubs', :git => 'https://github.com/eman6576/OHHTTPStubs'
        pod 'OHHTTPStubs/Swift', :git => 'https://github.com/eman6576/OHHTTPStubs'
    end
    
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ENABLE_STRICT_OBJC_MSGSEND'] = "NO"
            if target.name == 'ImagePicker'
                config.build_settings['SWIFT_VERSION'] = '4.0'
                else
                config.build_settings['SWIFT_VERSION'] = '3.2'
            end
            config.build_settings['CLANG_ENABLE_CODE_COVERAGE'] = "NO"
        end
    end
end
