//
//  CroppableImageEditView.swift
//  DropResizeImage
//
//  Created by Joe Jarriel on 11/19/25.
//

//
//  ContentView.swift
//  DropResizeImage
//
//  Created by Joe Jarriel on 11/12/25.
//
import OSLog
import SwiftUI
import UIKit

struct CircleCroppedImage: View {
    //MARK: Variable initialization
    var profileImage: ProfileImage
    
    var body: some View {
        GeometryReader { geometry in
            /// Geometry reader provides a reference to the upper, leading corner of the image space.
            ZStack {
                profileImage.image
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(profileImage.scaleFactor)
                    .position(position(in: geometry))
                    .clipShape(Circle())
                    .contentShape(Circle())
            }
        }
    }
        
    // MARK: Position
    private func position(in geometry: GeometryProxy) -> CGPoint {
        let x = geometry.frame(in: .local).midX + profileImage.panOffset.width
        let y = geometry.frame(in: .local).midY + profileImage.panOffset.height
        
        return CGPoint(x: x, y: y)
    }
}



