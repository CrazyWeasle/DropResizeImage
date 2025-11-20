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

struct CircleCroppedImageView: View {
    //MARK: Variable initialization
    @Bindable var editableImageData: EditableImageData
    
    @State var editableUIImage: UIImage? = nil
    @State var imageScaleFactor: CGFloat = 1
    @State var imagePanOffset: CGSize = .zero

    @State var showImagePicker: Bool = false
    @State var editMode: Bool = false

    var body: some View {
        VStack {
            // MARK: Image views
            GeometryReader { geometry in
                /// Geometry reader provides a reference to the upper, leading corner of the image space.
                ZStack {
                    editableImage
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(scaleFactor)
                        .position(position(in: geometry))
                        .clipShape(Circle())
                        .gesture(editMode ? panGesture().simultaneously(with: scaleGesture()) : nil)
                }
            }
            .frame(width: 200, height: 200)
            .onTapGesture(count: 2) { editMode ? showImagePicker.toggle() : () }
            .padding()
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $editableUIImage)
            }
            .onAppear() {
                editableUIImage = editableImageData.uiImage
                imageScaleFactor = editableImageData.scaleFactor
                imagePanOffset = editableImageData.panOffset
            }
            // MARK: Edit Mode/View Mode Buttons
            if editMode {
                HStack {
                    Button("Cancel") {
                        editableUIImage = editableImageData.uiImage
                        imageScaleFactor = editableImageData.scaleFactor
                        imagePanOffset = editableImageData.panOffset
                        editMode = false
                    }
                    .buttonStyle(CapsuleButtonStyle())
                    
                    Button("Save") {
                        if let editableUIImage {
                            editableImageData.updateImageData(editableUIImage)
                            editableImageData.scaleFactor = imageScaleFactor
                            editableImageData.panOffset = imagePanOffset
                        }
                        editMode = false
                    }
                    .buttonStyle(CapsuleButtonStyle())
                }
            } else {
                Button("Edit") {
                    editableUIImage = editableImageData.uiImage
                    imageScaleFactor = editableImageData.scaleFactor
                    imagePanOffset = editableImageData.panOffset
                    editMode = true
                }
                .buttonStyle(CapsuleButtonStyle())
            }
        }
    }
    
    //MARK: Image in view
    private var editableImage: Image {
        if let editableUIImage {
            return Image(uiImage: editableUIImage)
        } else {
            return Image(systemName: "plus")
        }
            
    }
            
    // MARK: Panning
    @GestureState private var gesturePanOffset: CGSize = CGSize.zero

    private func position(in geometry: GeometryProxy) -> CGPoint {
        // = center of space + initial offsets from struct + changed offsets
        let x = geometry.frame(in: .local).midX + currentPosition.width
        let y = geometry.frame(in: .local).midY + currentPosition.height
        
        return CGPoint(x: x, y: y)
    }

    private var currentPosition: CGSize {
        imagePanOffset + gesturePanOffset
    }
    
    private func panGesture() -> some Gesture {
        DragGesture()
            .updating($gesturePanOffset) { latestDragGestureValue, gesturePanOffset, _ in
                gesturePanOffset = latestDragGestureValue.translation
            }
            .onEnded { finalDragGestureValue in
                imagePanOffset = imagePanOffset + finalDragGestureValue.translation
            }
    }
    
    // MARK: - Scaling
    @GestureState private var gestureScaleFactor: CGFloat = 1
    
    private var scaleFactor: CGFloat {
        imageScaleFactor * gestureScaleFactor
    }
    
    private func scaleGesture() -> some Gesture {
        MagnificationGesture()
            .updating($gestureScaleFactor) { latestGestureScale, gestureScaleFactor, _ in
                gestureScaleFactor = latestGestureScale
            }
            .onEnded { gestureScaleAtEnd in
                let newScale = max(0.2, min(5.0, imageScaleFactor * gestureScaleAtEnd))
                imageScaleFactor = newScale
            }
    }
}

#Preview() {
    ContentView()
}


