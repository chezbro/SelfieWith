# -*- coding: utf-8 -*-
$:.unshift('/Library/RubyMotion/lib')
require 'motion/project/template/ios'
require 'bundler'
Bundler.require

# require 'bubble-wrap'

Motion::Project::App.setup do |app|

  app.name = 'SelfieWith'
  app.identifier = 'co.selfiewith.selfiewith'
  app.short_version = '0.1.0'
  app.version = app.short_version
  app.info_plist['UIViewControllerBasedStatusBarAppearance'] = false
  app.status_bar_style = :light_content
  app.seed_id = 'TX44FE7KFR'

  app.entitlements['keychain-access-groups'] = [
    app.seed_id + '.' + app.identifier
  ]

  # SDK 8 for iOS 8 and above
  # app.sdk_version = '8.1'
  # app.deployment_target = '8.0'

  # SDK 8 for iOS 7 and above
  app.sdk_version = '8.1'
  app.deployment_target = '7.1'

  # Or for SDK 7
  # app.sdk_version = '7.1'
  # app.deployment_target = '7.0'

  app.icons = ["icon@2x.png", "icon-29@2x.png", "icon-40@2x.png", "icon-60@2x.png", "icon-76@2x.png", "icon-512@2x.png"]

  # prerendered_icon is only needed in iOS 6
  #app.prerendered_icon = true

  app.testflight.api_token = '0149b47f68c72f39b0d0f174889f0d55_MTA4NjAxODIwMTMtMDYtMDIgMDQ6Mzc6NTcuMDI4Mjc0'
  app.testflight.team_token = '21a3141dc19bf01f9bebadb4776b9904_NDA3NjU4MjAxNC0wNy0xNyAyMjo1NjoxNy40MDUzMDk '
  app.testflight.notify = true
  app.testflight.identify_testers = true
  app.testflight.distribution_lists = ['SelfieWith']

  app.device_family = [:iphone]
  app.interface_orientations = [:portrait, :portrait_upside_down]

  app.files += Dir.glob(File.join(app.project_dir, 'lib/**/*.rb'))

  # Use `rake config' to see complete project settings, here are some examples:
  #
  # app.fonts = ['Oswald-Regular.ttf', 'FontAwesome.otf'] # These go in /resources
  app.frameworks += %w(QuartzCore CoreGraphics AVFoundation MediaPlayer MessageUI CoreData)

  # app.vendor_project('vendor/Flurry', :static)
  # app.vendor_project('vendor/DSLCalendarView', :static, :cflags => '-fobjc-arc') # Using arc
  #
  app.pods do
  #   pod 'AFNetworking'
  #   pod 'SVProgressHUD'
    pod 'JMImageCache'
    pod 'EAIntroView', '~> 2.6'
    pod 'FontAwesomeKit/IonIcons'
    pod 'EBPhotoPages', '~> 0.9.1'
  end

  app.codesign_certificate                = 'iPhone Distribution: eric chesbrough (TX44FE7KFR)'
  app.provisioning_profile                = 'SelfieWithDistribution.mobileprovision'
  app.entitlements['aps-environment']     = 'production'
  app.entitlements['get-task-allow']      = true
  app.entitlements['beta-reports-active'] = true
end
