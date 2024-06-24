//
// SwiftGen
// Copyright © 2022 SwiftGen
// MIT Licence
//
import Foundation
import PathKit

public enum OutputDestination {
  case console
  case file(Path)

  public var description: String {
    switch self {
    case .console:
      return "(stdout)"
    case .file(let path):
      return path.description
    }
  }
}

extension OutputDestination {
  public func write(
    content: String,
    onlyIfChanged: Bool = false,
    logger: (LogLevel, String) -> Void = logMessage
  ) throws {
    switch self {
    case .console:
      print(content)
    case .file(let path):
      if try onlyIfChanged && path.exists && path.read(.utf8) == content {
        logMessage(.info, "Not writing the file as content is unchanged, but updating attributes")
        let now = Date()
        try FileManager.default.setAttributes([.creationDate: now, .modificationDate: now], ofItemAtPath: path.string)
        return
      }
      try path.write(content)
      logMessage(.info, "File written: \(path)")
    }
  }
}
