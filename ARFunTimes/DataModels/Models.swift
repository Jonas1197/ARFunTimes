//
//  Models.swift
//  ARFunTimes
//
//  Created by Jonas Gamburg on 04.11.22.
//

import ARKit
import RealityKit

struct CustomARConfiguration {
    var focusEntityEnabled:     Bool    = true
    var focusEntityColor:       UIColor = .yellow
    var addsEntityOnTapEnabled: Bool    = false
    var entityType:             RealityKitView.Coordinator.EntityType = .dice
    var entityScale:            SIMD3<Float> = [0.1, 0.1, 0.1]
    
    static let dice = CustomARConfiguration(focusEntityEnabled: true,
                                            addsEntityOnTapEnabled: true,
                                            entityType: .dice,
                                            entityScale: [0.2, 0.2, 0.2])
    
    static let bottle = CustomARConfiguration(focusEntityEnabled: true,
                                              addsEntityOnTapEnabled: true,
                                              entityType: .beerBottle,
                                              entityScale: [0.01, 0.01, 0.01])
    
    static let wilhelm = CustomARConfiguration(focusEntityEnabled: true,
                                              addsEntityOnTapEnabled: true,
                                              entityType: .wilhelm,
                                               entityScale: [0.7, 0.7, 0.7])
}

final class RealityKitViewStateModel: ObservableObject {
    var model: CustomARConfiguration
    var fusRoDah: Bool
        
    init(model: CustomARConfiguration, fusRoDah: Bool = false) {
        self.model    = model
        self.fusRoDah = fusRoDah
    }
}
