//
//  ContentView.swift
//  DropResizeImage
//
//  Created by Joe Jarriel on 11/12/25.
//
import OSLog
import SwiftUI
import UIKit

struct ContentView: View {
    //MARK: Variable initialization
    @State var editableImageData: EditableImageData = EditableImageData()

    var body: some View {
        @Bindable var editableImageData = editableImageData
        
        VStack {
            CircleCroppedImageView(editableImageData: editableImageData)
                .padding()
            
            ZStack {
                GeometryReader { geometry in
                    editableImageData.image
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(editableImageData.scaleFactor)
                        .position(
                            x: geometry.frame(in: .local).midX + editableImageData.panOffset.width,
                            y: geometry.frame(in: .local).midY + editableImageData.panOffset.height
                        )
                        .clipShape(Circle())
                        .contentShape(Circle())
                }
            }
            .frame(width: 250, height: 250)
            .padding()
        }
    }
}

#Preview() {
    ContentView()
}


