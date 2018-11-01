Pod::Spec.new do |s|
    s.name             = 'Bitcoin'
    s.version          = '0.1.0'
    s.summary          = 'Swift bindings for libbitcoin.'

    # s.description      = <<-DESC
    # TODO: Add long description of the pod here.
    # DESC

    s.homepage         = 'https://github.com/wolfmcnally/Bitcoin'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Wolf McNally' => 'wolf@wolfmcnally.com' }
    s.source           = { :git => 'https://github.com/wolfmcnally/Bitcoin.git', :tag => s.version.to_s }

    s.swift_version = '4.2'

    s.source_files = 'Bitcoin/Classes/**/*'

    s.ios.deployment_target = '9.3'
    s.macos.deployment_target = '10.13'
    s.tvos.deployment_target = '11.0'

    s.module_name = 'Bitcoin'

    s.dependency 'CBitcoin'
    s.dependency 'WolfPipe'
end
