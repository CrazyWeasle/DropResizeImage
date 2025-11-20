//
//  CapsuleButtonStyle.swift
//  DropResizeImage
//
//  Created by Joe Jarriel on 11/19/25.
//

import SwiftUI

struct CapsuleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 80)
            .foregroundStyle(Color(.white))
            .background(.blue)
            .opacity(configuration.isPressed ? 0.7 : 1.0)
            .containerShape(Capsule())
        
    }
}
