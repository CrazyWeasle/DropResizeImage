//
//  CroppableImage.swift
//  DropResizeImage
//
//  Created by Joe Jarriel on 11/17/25.
//

import SwiftUI

@Observable
public class ProfileImage: Identifiable, Equatable {
    public var id: UUID = UUID()
    public var imageData: Data?
    
    private var _scaleFactor: CGFloat = 1
    public var scaleFactor: CGFloat {
        get { _scaleFactor }
        set {
            // Clamp to allowable bounds
            _scaleFactor = min(max(newValue, 0.1), 10)
        }
    }
    
    public var panOffset: CGSize = CGSize.zero
    
    // MARK: Initializers
    ///Will need to determine if the simplest initializer satisfies cloudkit's requirements
    init(imageData: Data? = nil) {
        self.imageData = imageData
    }
    
    public var uiImage: UIImage? {
        if let data = imageData, let uiImage = UIImage(data: data) {
            return uiImage
        }
        return nil
    }
    
    public var image: Image {
        if let uiImage {
            return Image(uiImage: uiImage)
        }
        return Image(systemName: "questionmark.circle.fill")
    }
    
    public func setImage(_ uiImage: UIImage) {
        guard let jpeg = uiImage.jpegData(compressionQuality: 0.8) else {
            print("⚠️ Failed to convert UIImage to JPEG data")
            return
        }
        imageData = jpeg
    }
    
    // MARK: Equatable Conformance
    public static func == (lhs: ProfileImage, rhs: ProfileImage) -> Bool {
        // Compare by ID for reference equality
        lhs.id == rhs.id &&
        lhs.imageData == rhs.imageData &&
        lhs.scaleFactor == rhs.scaleFactor &&
        lhs.panOffset == rhs.panOffset
    }
}
