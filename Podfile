# Uncomment the next line to define a global platform for your project
# platform :ios, '14.0'

target 'Refuge' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  post_install do |installer|
      installer.generated_projects.each do |project|
          project.targets.each do |target|
                 target.build_configurations.each do |config|
                     config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
     config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
                   end
               end
           end
       end

  # Pods for Refuge

  target 'RefugeTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'RefugeUITests' do
    # Pods for testing
  end

  pod 'Alamofire', '~> 5.6.4'
  pod 'NukeUI', '~> 0.8.0'
  pod 'SwiftSoup'
  pod 'AlertToast'

end
