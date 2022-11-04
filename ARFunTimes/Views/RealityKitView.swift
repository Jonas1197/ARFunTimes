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


struct RealityKitView: UIViewRepresentable {
    
    var stateModel: RealityKitViewStateModel
    private var objects: [Entity] = []
    
    //MARK: - Lifecycle
    init(stateModel: RealityKitViewStateModel) {
        self.stateModel = stateModel
    }
    
    func makeUIView(context: Context) -> ARView {
       setUp(context)
        
//        MARK: Set debug options
//        #if DEBUG
//        view.debugOptions = [.showFeaturePoints, .showAnchorOrigins, .showAnchorGeometry]
//        #endif
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
        
        if stateModel.shouldAddEntity {
            context.coordinator.customConfiguration = self.stateModel.model
            context.coordinator.addEntity(.init())
            stateModel.shouldAddEntity = false
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    
    //MARK: - Setup
    private func setUp(_ context: Context) -> ARView {
        let view    = ARView()
        let session = createArSession(view)
        addCoachingOveraly(arView: view, session: session)
        configureCoordinator(context, arView: view, session: session)
        addTaps(context, view)
        
        return view
    }
    
    private func createArSession(_ arView: ARView) -> ARSession {
        //MARK: Start AR Session
        let session           = arView.session
        let config            = ARWorldTrackingConfiguration()
        config.planeDetection = .horizontal
        session.run(config)
        return session
    }
    
    private func addCoachingOveraly(arView: ARView, session: ARSession) {
        //MARK: Add coaching overlay
        let coachingOverlay              = ARCoachingOverlayView()
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        coachingOverlay.session          = session
        coachingOverlay.goal             = .horizontalPlane
        arView.addSubview(coachingOverlay)
    }
    
    private func configureCoordinator(_ context: Context, arView: ARView, session: ARSession) {
        //MARK: Handle AR Session events
        context.coordinator.view                = arView
        context.coordinator.customConfiguration = stateModel.model
        session.delegate                        = context.coordinator
    }
    
    private func addTaps(_ context: Context, _ arView: ARView) {
        
        //MARK: Handle taps
        if stateModel.model.addsEntityOnTapEnabled {
            let tap = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.addEntity(_:)))
            arView.addGestureRecognizer(tap)
        }
    }
}
