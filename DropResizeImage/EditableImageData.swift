//
//  CroppableImage.swift
//  DropResizeImage
//
//  Created by Joe Jarriel on 11/17/25.
//

import SwiftUI

@Observable
public class EditableImageData: Identifiable {
    public var id: UUID = UUID()
    public var imageData: Data?
    public var scaleFactor: CGFloat = 1
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
    
    public func updateImageData(_ uiImage: UIImage) {
        if let jpeg = uiImage.jpegData(compressionQuality: 0.8) {
            imageData = jpeg
        }
    }
    
    public func updateScaleFactor(_ zoomFactor: CGFloat) {
        self.scaleFactor = zoomFactor
    }
    
    public func updatePanOffset(_ panOffset: CGSize) {
        self.panOffset = panOffset
    }
}
