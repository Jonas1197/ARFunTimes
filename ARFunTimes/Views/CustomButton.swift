//
//  CustomButton.swift
//  ARFunTimes
//
//  Created by Jonas Gamburg on 02.11.22.
//

import SwiftUI

struct CustomButton: View {
    
    var title:      String
    var color:      Color
    var isSelected: Bool = false
    var action:     () -> Void
    
    var body: some View {
        
        Button {
            withAnimation {
                action()
            }
            
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .stroke(.white, lineWidth: isSelected ? 4 : 0)
                    .background(color)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                    .frame(width: 120, height: 60)
                    
                
                Text(title)
                    .foregroundColor(color == .white ? .black : .white)
                    .font(.system(size: 16, weight: .semibold))
            }
        }
        
    }
}

