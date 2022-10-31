//
//  RealityKitView.swift
//  ARFunTimes
//
//  Created by Jonas Gamburg on 31.10.22.
//

import SwiftUI
import ARKit
import RealityKit
import FocusEntity

struct CustomARConfiguration {
    var focusEntityEnabled:     Bool    = true
    var focusEntityColor:       UIColor = .yellow
    var addsEntityOnTapEnabled: Bool    = false
    var entityType:             RealityKitView.Coordinator.EntityType = .dice
    var entityScale:            SIMD3<Float> = [0.1, 0.1, 0.1]
    
    static let dice = CustomARConfiguration(focusEntityEnabled: true,
                                            focusEntityColor: .yellow,
                                            addsEntityOnTapEnabled: true,
                                            entityType: .dice,
                                            entityScale: [0.2, 0.2, 0.2])
    
    static let bottle = CustomARConfiguration(focusEntityEnabled: true,
                                              focusEntityColor: .yellow,
                                              addsEntityOnTapEnabled: true,
                                              entityType: .beerBottle,
                                              entityScale: [0.01, 0.01, 0.01])
}

final class RealityKitViewStateModel: ObservableObject {
    var model: CustomARConfiguration
    var fusRoDah: Bool
        
    init(model: CustomARConfiguration, fusRoDah: Bool = false) {
        self.model    = model
        self.fusRoDah = fusRoDah
    }
}

struct RealityKitView: UIViewRepresentable {
    
    var stateModel: RealityKitViewStateModel
    private var objects: [Entity] = []
    
    init(stateModel: RealityKitViewStateModel) {
        self.stateModel = stateModel
    }
    
    func makeUIView(context: Context) -> ARView {
        let view = ARView()
        
        //MARK: Start AR Session
        let session           = view.session
        let config            = ARWorldTrackingConfiguration()
        config.planeDetection = .horizontal
        session.run(config)
        
        
        //MARK: Add coaching overlay
        let coachingOverlay              = ARCoachingOverlayView()
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        coachingOverlay.session          = session
        coachingOverlay.goal             = .horizontalPlane
        view.addSubview(coachingOverlay)
        
        
        //MARK: Set debug options
        #if DEBUG
//        view.debugOptions = [.showFeaturePoints, .showAnchorOrigins, .showAnchorGeometry]
        #endif
        
        
        //MARK: Handle AR Session events
        context.coordinator.view                = view
        context.coordinator.customConfiguration = stateModel.model
        session.delegate                        = context.coordinator
        
        
        //MARK: Handle taps
        if stateModel.model.addsEntityOnTapEnabled {
            let tap = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.addEntity(_:)))
            view.addGestureRecognizer(tap)
        }
        
        return view
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        //MARK: Handle taps
        if stateModel.model.addsEntityOnTapEnabled {
            context.coordinator.customConfiguration = self.stateModel.model
            let tap = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.addEntity(_:)))
            uiView.addGestureRecognizer(tap)
        } else {
            uiView.gestureRecognizers?.forEach(uiView.removeGestureRecognizer(_:))
        }
        
        if stateModel.fusRoDah {
            context.coordinator.fusRoDahEverything()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    
    //MARK: - Coordinator
    class Coordinator: NSObject, ARSessionDelegate {
        enum EntityType: String {
            case dice       = "Dice"
            case beerBottle = "BeerBottle"
        }
        
        weak var view: ARView?
        var customConfiguration: CustomARConfiguration?
        var planeEntity: ModelEntity!
        var focusEntity: FocusEntity?
        private var entities: [ModelEntity] = []
        
        func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
            guard let view = self.view else { return }
            
            guard focusEntity != nil else {
                self.focusEntity = .init(on: view, style: .classic(color: customConfiguration?.focusEntityColor ?? .yellow))
                return
            }
        }
        
        @objc func addEntity(_ sender: UITapGestureRecognizer) {
            guard let view        = self.view,
                  let focusEntity = self.focusEntity,
                  let config      = self.customConfiguration else { return }
            
            //MARK: Create a new anchor to ad  content to
            let anchor = AnchorEntity()
            view.scene.anchors.append(anchor)
            
            
            print("\n~~> Entity type: \(config.entityType.rawValue)")
//            let entity = ModelEntity(mesh: .generateBox(size: 0.5))
            
            guard let entity = try? ModelEntity.loadModel(named: config.entityType.rawValue) else {
                debugPrint("\n~~> Failed to add entity, invalid asset name...")
                return
            }
            
            entity.scale    = config.entityScale
            entity.position = focusEntity.position
//
            let size     = entity.visualBounds(relativeTo: entity).extents
            let boxShape = ShapeResource.generateBox(size: size)

            entity.generateCollisionShapes(recursive: true)
            let physics = PhysicsBodyComponent(massProperties: .init(shape: boxShape, mass: 5),
                                               material:       .default,
                                               mode:           .dynamic)
            entity.components.set(physics)
            
            anchor.addChild(entity)
            self.entities.append(entity)
            
            
            
            guard planeEntity == nil else { return }
            let planeMesh = MeshResource.generatePlane(width: 100, depth: 1)
            let material  = SimpleMaterial(color: .init(white: 1.0, alpha: 0.0), isMetallic: false)
            
            planeEntity             = ModelEntity(mesh: planeMesh, materials: [material])
            planeEntity.position    = focusEntity.position
            planeEntity.physicsBody = PhysicsBodyComponent(massProperties: .default, material: nil, mode: .static)
            planeEntity.collision   = CollisionComponent(shapes: [.generateBox(width: 2, height: 0.001, depth: 2)])
            let position: SIMD3<Float> = [focusEntity.position.x, focusEntity.position.y - 0.1, focusEntity.position.z]
            planeEntity.position    = position
            
            anchor.addChild(planeEntity)
        }
        
        func fusRoDahEverything() {
            for entity in self.entities {
                
                entity.addForce([0, 4, 0], relativeTo: nil)
                entity.addTorque([Float.random(in: 0 ... 1), Float.random(in: 0 ... 1), Float.random(in: 0 ... 1)], relativeTo: nil)
            }
        }
    }
}
