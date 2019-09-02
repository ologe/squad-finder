import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    var keys: NSDictionary?
    if let path = Bundle.main.path(forResource: "keys", ofType: "plist"){
        keys = NSDictionary(contentsOfFile: path)
    }
    if let dict = keys {
        if let mapsKey = dict["MapsKey"] as? String{
            GMSServices.provideAPIKey(mapsKey)
        }
    }
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
