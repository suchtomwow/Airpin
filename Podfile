platform :ios, '10.0'

use_frameworks!
inhibit_all_warnings!

target 'Airpin' do

  pod 'Realm'
  pod 'RealmSwift'
  pod 'SwiftyJSON'
  pod 'Locksmith'
  pod 'Crashlytics'
  pod 'Fabric'
  pod 'Eureka'

  post_install do |installer|
      installer.pods_project.targets.each do |target|
        if target.name == "Eureka"
	  target.build_configurations.each do |config|
	      config.build_settings['SWIFT_VERSION'] = '4.0'
            end
	  end
      end
  end
end

target 'Airpin Tests' do

end
