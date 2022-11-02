//
//  ContentView.swift
//  ARFunTimes
//
//  Created by Jonas Gamburg on 31.10.22.
//

import SwiftUI

struct ContentView: View {
    
    @State var realityKitViewModel: RealityKitViewStateModel = .init(model: .dice)
    
    var body: some View {
        
        ZStack {
            let _ = print("scene: \(realityKitViewModel.model)")
            
            RealityKitView(stateModel: realityKitViewModel)
            .ignoresSafeArea()
            
            HStack {
               
                VStack {
                    Spacer()
                    
                    CustomButton(
                        title: "Coca Cola",
                        color: .red,
                        isSelected: realityKitViewModel.model.entityType == .beerBottle) {
                            realityKitViewModel = .init(model: .bottle)
                        }
                    
                    CustomButton(
                        title: "Dice",
                        color: .blue,
                        isSelected: realityKitViewModel.model.entityType == .dice) {
                            realityKitViewModel = .init(model: .dice)
                        }
                }
                .padding([.leading, .bottom], 24)
                
                Spacer()
                VStack {
                    Spacer()
                    
                    CustomButton(
                        title: "FUS RO DAH",
                        color: .purple,
                        isSelected: false) {
                            realityKitViewModel = .init(model: realityKitViewModel.model, fusRoDah: true)
                        }
                }
                .padding([.trailing, .bottom], 24)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
