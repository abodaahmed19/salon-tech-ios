platform :ios, '15.0'

target 'salon' do
  use_frameworks!

  pod 'Alamofire'
  pod 'AlamofireImage'
  pod 'SwiftyJSON'
  pod 'ObjectMapper'
  pod 'SDWebImage'
  pod 'SideMenu', '~> 5.0.1'
  pod 'MBProgressHUD'
  pod 'ImageSlideshow'
  pod 'SVProgressHUD'
  pod 'DropDown'
  pod 'SCLAlertView'

  # XCFramework distribution supports Apple Silicon iOS simulators.
  pod 'GoogleMaps', '= 8.4.0'

  pod 'Firebase/Analytics', '~> 11.0'
  pod 'Firebase/Messaging', '~> 11.0'
  pod 'Firebase/Firestore', '~> 11.0'
  pod 'Firebase/Database', '~> 11.0'

  pod 'MyFatoorah'
  pod 'PusherSwift'

  pod 'FacebookCore'
  pod 'FacebookLogin'
  pod 'FBSDKCoreKit'
  pod 'FBSDKLoginKit'

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
        # Xcode 15+ archives C++ pods (leveldb/gRPC) as ObjC modules and fails
        # with quoted-include + 'cstdint' file not found.
        config.build_settings['CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER'] = 'NO'
        config.build_settings['ENABLE_MODULE_VERIFIER'] = 'NO'
        config.build_settings['CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES'] = 'YES'
      end

      if target.name == 'BoringSSL-GRPC'
        target.source_build_phase.files.each do |file|
          next unless file.settings && file.settings['COMPILER_FLAGS']

          flags = file.settings['COMPILER_FLAGS'].split
          flags.reject! { |flag| flag == '-GCC_WARN_INHIBIT_ALL_WARNINGS' }
          file.settings['COMPILER_FLAGS'] = flags.join(' ')
        end
      end
    end
  end
end
