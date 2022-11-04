//
//  RealityKitViewCoordinator.swift
//  ARFunTimes
//
//  Created by Jonas Gamburg on 04.11.22.
//

import RealityKit
import ARKit
import FocusEntity

extension RealityKitView {
    
    
    //MARK: - Coordinator
    final class Coordinator: NSObject, ARSessionDelegate {
        enum EntityType: String {
            case dice       = "Dice"
            case beerBottle = "BeerBottle"
            case wilhelm    = "Wilhelm"
        }
        
        weak var view: ARView?
        var customConfiguration: CustomARConfiguration?
        var planeEntity:         ModelEntity!
        var focusEntity:         FocusEntity?
        private var entities:    [ModelEntity] = []
        
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
            
            //MARK: Create a new anchor to add content to
            let anchor = AnchorEntity()
            view.scene.anchors.append(anchor)
            
            
            
            //MARK: Load plane
            // So that the models spawn on it and won't fall off immediatelly.
            if planeEntity == nil {
                let planeMesh = MeshResource.generatePlane(width: 100, depth: 1)
                let material  = SimpleMaterial(color: .init(white: 1.0, alpha: 0.0), isMetallic: false)
                
                planeEntity             = ModelEntity(mesh: planeMesh, materials: [material])
                planeEntity.position    = focusEntity.position
                planeEntity.physicsBody = PhysicsBodyComponent(massProperties: .default, material: nil, mode: .static)
                planeEntity.collision   = CollisionComponent(shapes: [.generateBox(width: 2, height: 0.001, depth: 100)])
                
                let position: SIMD3<Float> = [focusEntity.position.x, focusEntity.position.y - 0.1, focusEntity.position.z]
                planeEntity.position       = position
                
                anchor.addChild(planeEntity)
            }
            
            
            //MARK: Load the entity from the .usdz assets
            guard let entity = try? ModelEntity.loadModel(named: config.entityType.rawValue) else {
                debugPrint("\n~~> Failed to add entity, invalid asset name...")
                return
            }
            
            
            //MARK: Scaling and positioning
            entity.scale    = config.entityScale
            entity.position = focusEntity.position
            
            
            //MARK: Add physics to the object
            let size     = entity.visualBounds(relativeTo: entity).extents
            let boxShape = ShapeResource.generateBox(size: size)
            entity.generateCollisionShapes(recursive: true)
            let physics = PhysicsBodyComponent(massProperties: .init(shape: boxShape, mass: 5),
                                               material:       .default,
                                               mode:           .dynamic)
            entity.components.set(physics)
            
            
            //MARK: Add object to the world
            anchor.addChild(entity)
            self.entities.append(entity)
        }
        
        /// It does what it says in the title.
        func fusRoDahEverything() {
            for entity in self.entities {
                entity.addForce([0, 4, 0], relativeTo: nil)
                entity.addTorque([Float.random(in: 0 ... 1),
                                  Float.random(in: 0 ... 1),
                                  Float.random(in: 0 ... 1)],
                                 relativeTo: nil)
            }
        }
    }
}
