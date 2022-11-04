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
            
            
            VStack {
                Spacer()

                CustomButton(symbol: "plus", color: .blue) {
                    realityKitViewModel = .init(model: realityKitViewModel.model, shouldAddEntity: true)
                }
                .frame(maxHeight: 40)
                .padding(.bottom, 8)

                HStack(spacing: 16) {
                    CustomButton(
                        title: "Wilhelm",
                        color: .red,
                        isSelected: realityKitViewModel.model.entityType == .wilhelm) {
                            realityKitViewModel = .init(model: .wilhelm)
                        }

                    CustomButton(
                        title: "FUS RO DAH",
                        color: .purple,
                        isSelected: false) {
                            realityKitViewModel = .init(model: realityKitViewModel.model, fusRoDah: true)
                        }

                    CustomButton(
                        title: "Dice",
                        color: .gray,
                        isSelected: realityKitViewModel.model.entityType == .dice) {
                            realityKitViewModel = .init(model: .dice)
                        }
                }
                .frame(maxHeight: 40)
            }
            .padding([.leading, .trailing])
            
//            HStack {
//                VStack {
//                    CustomButton(symbol: "plus", color: .blue) {
//                        realityKitViewModel = .init(model: realityKitViewModel.model, shouldAddEntity: true)
//                    }
//
//                    Spacer()
//
//                    CustomButton(
//                        title: "Wilhelm",
//                        color: .red,
//                        isSelected: realityKitViewModel.model.entityType == .wilhelm) {
//                            realityKitViewModel = .init(model: .wilhelm)
//                        }
//
//                    CustomButton(
//                        title: "Dice",
//                        color: .gray,
//                        isSelected: realityKitViewModel.model.entityType == .dice) {
//                            realityKitViewModel = .init(model: .dice)
//                        }
//                }
//                .padding([.leading, .bottom], 24)
//
//                Spacer()
//                VStack {
//                    Spacer()
//
//                    CustomButton(
//                        title: "FUS RO DAH",
//                        color: .purple,
//                        isSelected: false) {
//                            realityKitViewModel = .init(model: realityKitViewModel.model, fusRoDah: true)
//                        }
//                }
//                .padding([.trailing, .bottom], 24)
//            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
