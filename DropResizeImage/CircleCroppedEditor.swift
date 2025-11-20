//
//  CircleCroppedEditor.swift
//  DropResizeImage
//
//  Created by Joe Jarriel on 11/20/25.
//
import OSLog
import SwiftUI
import UIKit

struct CircleCroppedEditor: View {
    //MARK: Variable initialization
    @Bindable var profileImage: ProfileImage
    
    @State var workingUIImage: UIImage? = nil
    @State var workingScale: CGFloat = 1
    @State var workingOffset: CGSize = .zero

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
                        .contentShape(Circle())
                        .gesture(editMode ? panGesture().simultaneously(with: scaleGesture()) : nil)
                }
            }
            .onTapGesture(count: 2) { editMode ? showImagePicker.toggle() : () }
            .padding()
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(selectedImage: $workingUIImage)
            }
            .onAppear() {
                workingUIImage = profileImage.uiImage
                workingScale = profileImage.scaleFactor
                workingOffset = profileImage.panOffset
            }
            // MARK: Edit Mode/View Mode Buttons
            if editMode {
                HStack {
                    Button("Cancel") {
                        workingUIImage = profileImage.uiImage
                        workingScale = profileImage.scaleFactor
                        workingOffset = profileImage.panOffset
                        editMode = false
                    }
                    .buttonStyle(CapsuleButtonStyle())
                    
                    Button("Save") {
                        if let workingUIImage {
                            profileImage.setImage(workingUIImage)
                            profileImage.scaleFactor = workingScale
                            profileImage.panOffset = workingOffset
                        }
                        editMode = false
                    }
                    .buttonStyle(CapsuleButtonStyle())
                }
            } else {
                Button("Edit") {
                    workingUIImage = profileImage.uiImage
                    workingScale = profileImage.scaleFactor
                    workingOffset = profileImage.panOffset
                    editMode = true
                }
                .buttonStyle(CapsuleButtonStyle())
            }
        }
    }
    
    //MARK: Image in view
    private var editableImage: Image {
        if let workingUIImage {
            return Image(uiImage: workingUIImage)
        } else {
            return Image(systemName: "questionmark.circle.fill")
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
        workingOffset + gesturePanOffset
    }
    
    private func panGesture() -> some Gesture {
        DragGesture()
            .updating($gesturePanOffset) { latestDragGestureValue, gesturePanOffset, _ in
                gesturePanOffset = latestDragGestureValue.translation
            }
            .onEnded { finalDragGestureValue in
                workingOffset = workingOffset + finalDragGestureValue.translation
            }
    }
    
    // MARK: - Scaling
    @GestureState private var gestureScaleFactor: CGFloat = 1
    
    private var scaleFactor: CGFloat {
        workingScale * gestureScaleFactor
    }
    
    private func scaleGesture() -> some Gesture {
        MagnificationGesture()
            .updating($gestureScaleFactor) { latestGestureScale, gestureScaleFactor, _ in
                gestureScaleFactor = latestGestureScale
            }
            .onEnded { gestureScaleAtEnd in
                // Accumulate the scale, don't replace it
                workingScale = workingScale * gestureScaleAtEnd
            }
    }
}



