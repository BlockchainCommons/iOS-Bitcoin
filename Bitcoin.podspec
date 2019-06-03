Pod::Spec.new do |s|
    s.name             = 'Bitcoin'
    s.version          = '0.7.0'
    s.summary          = 'Swift bindings for libbitcoin, including Shamir Secret Sharing.'

    # s.description      = <<-DESC
    # TODO: Add long description of the pod here.
    # DESC

    s.homepage         = 'https://github.com/blockchaincommons/iOS-Bitcoin'
    s.license          = { :type => 'Apache', :file => 'LICENSE' }
    s.author           = { 'Wolf McNally' => 'wolf@wolfmcnally.com' }
    s.source           = { :git => 'https://github.com/blockchaincommons/iOS-Bitcoin.git', :tag => s.version.to_s }

    s.swift_version = '5.0'

    s.source_files = 'Sources/Bitcoin/**/*'

    s.ios.deployment_target = '11.0'
    #s.macos.deployment_target = '10.13'
    #s.tvos.deployment_target = '11.0'

    s.module_name = 'Bitcoin'

    s.dependency 'CBitcoin'
    s.dependency 'WolfCore'
end
