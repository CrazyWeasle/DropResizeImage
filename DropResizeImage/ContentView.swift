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
    @State var droppedUIImage: UIImage? = nil
    
    var body: some View {
        VStack {
            ZStack {
                GeometryReader { geometry in
                    Image(systemName: "plus")
                        .resizable()
                        .scaleEffect(zoomScale)
                        .opacity(0.1)
                    droppedImage
                        .resizable()
                        .scaledToFit()
                        .position(convertToCoordinates(in: geometry))
                        .dropDestination(for: Data.self) { items, location in
                            guard let imageData = items.first else { return }
                            guard let uiImage = UIImage(data: imageData) else { return }
                            droppedUIImage = uiImage
                        }
                        .gesture(panGesture().simultaneously(with: zoomGesture()))
                }
                .frame(width: 200, height: 200)
                .clipShape(Circle())
                .padding()
            }
            HStack {
                Button("Cancel") {
                    
                }
                .containerShape(.capsule)
                
                Button("Save") {
                    
                }
                .containerShape(.capsule)
            }
        }
    }
    
    var droppedImage: Image {
        if let droppedUIImage {
            return Image(uiImage: droppedUIImage)
        } else {
            return Image(systemName: "person")
        }
    }
    
    // MARK: - Zooming
    @State private var steadyStateZoomScale: CGFloat = 1
    @GestureState private var gestureZoomScale: CGFloat = 1
    
    private var zoomScale: CGFloat {
        steadyStateZoomScale * gestureZoomScale
    }
    
    private func zoomGesture() -> some Gesture {
        MagnificationGesture()
            .updating($gestureZoomScale) { latestGestureScale, gestureZoomScale, _ in
                gestureZoomScale = latestGestureScale
            }
            .onEnded { gestureScaleAtEnd in
                steadyStateZoomScale *= gestureScaleAtEnd
            }
    }
        
    private func zoomToFit(_ image: UIImage?, in size: CGSize) {
        if let image = image, image.size.width > 0, image.size.height > 0, size.width > 0, size.height > 0  {
            let hZoom = size.width / image.size.width
            let vZoom = size.height / image.size.height
            steadyStatePanOffset = .zero
            steadyStateZoomScale = min(hZoom, vZoom)
        }
    }
    
    // MARK: - Panning
    @State private var steadyStatePanOffset: CGSize = CGSize.zero
    @GestureState private var gesturePanOffset: CGSize = CGSize.zero
    
    private var panOffset: CGSize {
        (steadyStatePanOffset + gesturePanOffset) * zoomScale
    }
    
    private func panGesture() -> some Gesture {
        DragGesture()
            .updating($gesturePanOffset) { latestDragGestureValue, gesturePanOffset, _ in
                gesturePanOffset = latestDragGestureValue.translation / zoomScale
            }
            .onEnded { finalDragGestureValue in
                steadyStatePanOffset = steadyStatePanOffset + (finalDragGestureValue.translation / zoomScale)
            }
    }
    
//    private func convertToCoordinates(_ location: CGPoint, in geometry: GeometryProxy) -> CGPoint {
    private func convertToCoordinates(in geometry: GeometryProxy) -> CGPoint {
        let center = geometry.frame(in: .local).center
        let location = CGPoint(
            x: (panOffset.width - center.x) / zoomScale,
            y: (panOffset.height - center.y) / zoomScale
//            x: (location.x - panOffset.width - center.x) / zoomScale,
//            y: (location.y - panOffset.height - center.y) / zoomScale

        )
        return location
    }

}

#Preview {
    ContentView()
}
