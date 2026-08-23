// ios/Classes/VThumbnailPlugin.swift
import Flutter
import UIKit
import AVFoundation

public class VThumbnailPlugin: NSObject, FlutterPlugin {
  private let workQueue = DispatchQueue(label: "com.performance2024.vthumbnail.worker", qos: .userInitiated)

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "v_thumbnail", binaryMessenger: registrar.messenger())
    let instance = VThumbnailPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let args = call.arguments as? [String: Any],
          let videoPath = args["videoPath"] as? String else {
      result(FlutterError(code: "INVALID_ARGUMENT", message: "Video path is required", details: nil))
      return
    }

    let width = (args["width"] as? Int) ?? 100
    let height = (args["height"] as? Int) ?? 100

    switch call.method {
    case "generateThumbnail":
      let timeMs = (args["timeMs"] as? Int) ?? 0
      workQueue.async { [weak self] in
        guard let self = self else { return }
        let generator = self.makeImageGenerator(videoPath: videoPath)
        let path = self.extractFrame(generator: generator, timeMs: timeMs, width: width, height: height)
        DispatchQueue.main.async {
          if let path = path {
            result(path)
          } else {
            result(FlutterError(code: "THUMBNAIL_ERROR", message: "Could not extract frame at \(timeMs)ms", details: nil))
          }
        }
      }

    case "generateMultipleThumbnails":
      let count = (args["numberOfThumbnails"] as? Int) ?? 5
      guard count > 0 else {
        result([String]())
        return
      }
      workQueue.async { [weak self] in
        guard let self = self else { return }
        let generator = self.makeImageGenerator(videoPath: videoPath)
        let durationMs = CMTimeGetSeconds(generator.asset.duration) * 1000.0
        var paths: [String] = []
        for i in 0..<count {
          let timeMs = count == 1 ? 0 : Int(durationMs * Double(i) / Double(count))
          if let path = self.extractFrame(generator: generator, timeMs: timeMs, width: width, height: height) {
            paths.append(path)
          }
        }
        DispatchQueue.main.async { result(paths) }
      }

    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func makeImageGenerator(videoPath: String) -> AVAssetImageGenerator {
    let asset = AVAsset(url: URL(fileURLWithPath: videoPath))
    let generator = AVAssetImageGenerator(asset: asset)
    generator.appliesPreferredTrackTransform = true
    return generator
  }

  /// Runs on `workQueue`. Reuses `generator` so callers can extract several frames
  /// from the same video without re-parsing it each time.
  private func extractFrame(generator: AVAssetImageGenerator, timeMs: Int, width: Int, height: Int) -> String? {
    let time = CMTime(seconds: Double(timeMs) / 1000.0, preferredTimescale: 600)
    guard let cgImage = try? generator.copyCGImage(at: time, actualTime: nil) else {
      return nil
    }
    let image = UIImage(cgImage: cgImage)

    let size = CGSize(width: width, height: height)
    UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
    image.draw(in: CGRect(origin: .zero, size: size))
    let scaled = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    guard let data = scaled?.jpegData(compressionQuality: 0.9) else {
      return nil
    }

    // Caches directory is OS-managed (purged under disk pressure), unlike raw tmp files.
    guard let cachesDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
      return nil
    }
    let thumbnailDir = cachesDir.appendingPathComponent("v_thumbnail", isDirectory: true)
    try? FileManager.default.createDirectory(at: thumbnailDir, withIntermediateDirectories: true)

    let fileURL = thumbnailDir.appendingPathComponent("thumb_\(UUID().uuidString).jpg")
    do {
      try data.write(to: fileURL)
      return fileURL.path
    } catch {
      return nil
    }
  }
}
