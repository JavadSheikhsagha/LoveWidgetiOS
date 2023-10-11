//
//  AppState.swift
//  LoveWidget
//
//  Created by Javad on 10/7/23.
//

import SwiftUI

class AppState: ObservableObject {
    
    static let shared = AppState()
    
    init() {}
        
    @Published var filteredImage: CPImage?
    @Published var selectedImageFilter : String? = nil
    @Published var image: CPImage? {
        didSet {
            self.filteredImage = nil
        }
    }
}


#if os(iOS)
import UIKit
public typealias CPImage = UIImage
#elseif os(OSX)
import AppKit
public typealias CPImage = NSImage
#endif

extension CPImage {
    
    var coreImage: CIImage? {
        #if os(iOS)
        guard let cgImage = self.cgImage else {
            return nil
        }
        return CIImage(cgImage: cgImage)
        #elseif os(OSX)
        guard
            let tiffData = tiffRepresentation,
            let ciImage = CIImage(data: tiffData)
            else {
                return nil
        }
        return ciImage
        #endif
    }
}

extension CGImage {
    
    var cpImage: CPImage {
        #if os(iOS)
        return UIImage(cgImage: self)
        #elseif os(OSX)
        return NSImage(cgImage: self, size: .init(width: width, height: height))
        #endif
    }
}

extension Image {
    
    init(cpImage: CPImage) {
        #if os(iOS)
        self.init(uiImage: cpImage)
        #elseif os(OSX)
        self.init(nsImage: cpImage)
        #endif
    }
}
