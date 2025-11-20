//
//  View+CroppableImageView.swift
//  DropResizeImage
//
//  Created by Joe Jarriel on 11/19/25.
//

import SwiftUI

extension View {
    /// Displays a CroppableImage with its pan and scale transformations applied
    /// - Parameters:
    ///   - croppableImage: The image to display
    ///   - geometry: GeometryProxy for positioning
    /// - Returns: Transformed image view
    func circleCroppedImageView(_ croppableImage: EditableImageData) -> some View {
        GeometryReader { geometry in
            croppableImage.image
                .resizable()
                .scaledToFit()
                .scaleEffect(croppableImage.scaleFactor)
                .position(
                    x: geometry.frame(in: .local).midX + croppableImage.panOffset.width,
                    y: geometry.frame(in: .local).midY + croppableImage.panOffset.height
                )
                .clipShape(Circle())
                .contentShape(Circle())
        }
    }
}
