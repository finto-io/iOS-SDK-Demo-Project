use_frameworks!
platform :ios, '11.0'
source 'https://github.com/innovatrics/innovatrics-podspecs'
source 'https://github.com/finto-io/sdk-kyc-podspecs.git'


# path="https://BankalEtihad:TOKEN@github.com/BankalEtihad/sdk-kyc-iOS.git"

target 'kyc-ios-demo' do
  pod 'kyc-sdk', :git => "ssh://git@github.com:finto-io/sdk-kyc-podspecs.git"
  # pod 'kyc-sdk', :git => path, :tag => '3.3.0'

  target 'kyc-ios-demoTests' do
    inherit! :search_paths

  end
end
