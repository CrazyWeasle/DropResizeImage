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
    @State var editableImageData: ProfileImage = ProfileImage()

    var body: some View {
        @Bindable var editableImageData = editableImageData
        
        VStack {
            CircleCroppedEditor(profileImage: editableImageData)
                .frame(width: 200, height: 200)
                .padding()
            
            CircleCroppedImage(profileImage: editableImageData)
                .frame(width: 200, height: 200)
                .padding()
        }
    }
}

#Preview() {
    ContentView()
}


