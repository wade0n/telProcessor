Pod::Spec.new do |s|
  s.name = "TelProcessor"
  s.version = "0.0.1"
  s.summary = "It's module, that helps to fix telephone numbers with unnecessary symbols (like '%',':','|' and others) and show them in alert form call menu, there you able to fix number int textField, if region code is missing."
  s.homepage = "https://github.com/wade0n/telProcessor"
  s.license = { :type => 'MIT', :file => 'LICENSE'}
  s.author = { "Dmitrii Kalashnikov" => "mr.dmitriikalashnikov@gmail.com" }
  s.source = {
      :git => "https://github.com/wade0n/telProcessor.git",
      :tag => s.version.to_s
    }

  s.ios.deployment_target = '7.0'
  s.requires_arc = true
  s.default_subspec = 'core'

  s.subspec 'core' do |c|
    c.requires_arc = true
    c.dependency 'CXAlertView'
    c.source_files = 'core/source/*'
    c.resources = 'core/resources/*'
  end

end

