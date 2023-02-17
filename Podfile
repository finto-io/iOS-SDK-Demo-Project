use_frameworks!
platform :ios, '11.0'
source 'https://github.com/innovatrics/innovatrics-podspecs'
source 'https://github.com/finto-io/sdk-kyc-podspecs.git'


$tkn = 'ghp_y77' + 'cipBuozO0b7bLdkO' + 'XeAqCnkkcfk0hOM84'
$kycSdkSource = 'https://BankalEtihad:' + $tkn + '@github.com/BankalEtihad/sdk-kyc-iOS.git'

target 'kyc-ios-demo' do
  pod 'kyc-sdk', :tag => 'v3.3.0', :git => $kycSdkSource

  target 'kyc-ios-demoTests' do
    inherit! :search_paths


  end
end
