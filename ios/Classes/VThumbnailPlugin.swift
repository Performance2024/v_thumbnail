// ios/Classes/VThumbnailPlugin.swift
import Flutter
import UIKit
import AVFoundation

public class VThumbnailPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "v_thumbnail", binaryMessenger: registrar.messenger())
    let instance = VThumbnailPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "generateThumbnail":
      guard let args = call.arguments as? [String: Any],
            let videoPath = args["videoPath"] as? String else {
        result(FlutterError(code: "INVALID_ARGUMENT", message: "Video path is required", details: nil))
        return
      }
      
      let width = (args["width"] as? Int) ?? 100
      let height = (args["height"] as? Int) ?? 100
      let timeMs = (args["timeMs"] as? Int) ?? 0
      
      let asset = AVAsset(url: URL(fileURLWithPath: videoPath))
      let imageGenerator = AVAssetImageGenerator(asset: asset)
      imageGenerator.appliesPreferredTrackTransform = true
      
      let time = CMTime(seconds: Double(timeMs) / 1000.0, preferredTimescale: 600)
      
      do {
        let cgImage = try imageGenerator.copyCGImage(at: time, actualTime: nil)
        let thumbnail = UIImage(cgImage: cgImage)
        
        // Redimensionner l'image
        let size = CGSize(width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        thumbnail.draw(in: CGRect(origin: .zero, size: size))
        let scaledThumbnail = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Sauvegarder en fichier temporaire
        let tempDir = NSTemporaryDirectory()
        let thumbnailPath = (tempDir as NSString).appendingPathComponent("thumbnail_\(UUID().uuidString).jpg")
        
        if let data = scaledThumbnail?.jpegData(compressionQuality: 0.9) {
          try data.write(to: URL(fileURLWithPath: thumbnailPath))
          result(thumbnailPath)
        } else {
          result(FlutterError(code: "SAVE_ERROR", message: "Could not save thumbnail", details: nil))
        }
      } catch {
        result(FlutterError(code: "THUMBNAIL_ERROR", message: error.localizedDescription, details: nil))
      }
      
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}