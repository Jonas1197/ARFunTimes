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
                    
                    Button {
                        withAnimation {
                            realityKitViewModel = .init(model: .bottle)
                        }
                        
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(.white, lineWidth: realityKitViewModel.model.entityType == .beerBottle ? 4 : 0)
                                .background(Color.red)
                                .clipShape(RoundedRectangle(cornerRadius: 24))
                                .frame(width: 120, height: 60)
                                
                            
                            Text("Coca Cola")
                                .foregroundColor(.white)
                                .font(.system(size: 16, weight: .semibold))
                        }
                    }
                    
                    Button {
                        withAnimation {
                            realityKitViewModel = .init(model: .dice)
                        }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(.white, lineWidth: realityKitViewModel.model.entityType == .dice ? 4 : 0)
                                .background(Color.blue)
                                .clipShape(RoundedRectangle(cornerRadius: 24))
                                .frame(width: 120, height: 60)
                                
                            
                            Text("Dice")
                                .foregroundColor(.white)
                                .font(.system(size: 16, weight: .semibold))
                        }
                    }
                }
                .padding([.leading, .bottom], 24)
                
                Spacer()
                VStack {
                    Spacer()
                    Button {
                        realityKitViewModel = .init(model: realityKitViewModel.model, fusRoDah: true)
                        
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(.white, lineWidth: 0)
                                .background(Color.purple)
                                .clipShape(RoundedRectangle(cornerRadius: 24))
                                .frame(width: 120, height: 60)
                                
                            
                            Text("FUS RO DAH")
                                .foregroundColor(.white)
                                .font(.system(size: 16, weight: .semibold))
                        }
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
