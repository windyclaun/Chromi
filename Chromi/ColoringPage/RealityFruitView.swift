//
//  RealityFruitView.swift
//  Chromi
//
//  Created by Windy Claudia Napitupulu on 16/07/26.
//

import SwiftUI
import RealityKit

struct RealityFruitView: UIViewRepresentable {
    let modelName: String
    let yaw: Float
    let pitch: Float
    var isMonochrome: Bool = true

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero, cameraMode: .nonAR, automaticallyConfigureSession: false)
        arView.backgroundColor = .clear
        arView.environment.background = .color(.clear)
        arView.isUserInteractionEnabled = true
        arView.isMultipleTouchEnabled = true
        arView.renderOptions.insert(.disableMotionBlur)
        arView.renderOptions.insert(.disableDepthOfField)

        let anchor = AnchorEntity(world: .zero)
        arView.scene.addAnchor(anchor)

        let modelRoot = Entity()
        anchor.addChild(modelRoot)
        context.coordinator.rootEntity = modelRoot

        let fruitEntity: Entity
        if let entity = try? Entity.load(named: modelName) {
            entity.name = modelName
            if isMonochrome {
                applyMonochromeMaterials(to: entity)
            }
            fruitEntity = entity
        } else {
            let fallback = ModelEntity(
                mesh: .generateSphere(radius: 0.36),
                materials: [SimpleMaterial(color: .lightGray, roughness: 0.62, isMetallic: false)]
            )
            fruitEntity = fallback
        }

        modelRoot.addChild(fruitEntity)

        let bounds = fruitEntity.visualBounds(recursive: true, relativeTo: modelRoot)
        let center = SIMD3<Float>(
            (bounds.min.x + bounds.max.x) * 0.5,
            (bounds.min.y + bounds.max.y) * 0.5,
            (bounds.min.z + bounds.max.z) * 0.5
        )
        let extent = bounds.max - bounds.min
        let largestExtent = max(extent.x, max(extent.y, extent.z))
        let targetExtent: Float = 0.48
        let normalizedScale = largestExtent > 0 ? targetExtent / largestExtent : 1.0

        fruitEntity.position = -center
        modelRoot.scale = SIMD3<Float>(repeating: normalizedScale)

        let light = DirectionalLight()
        light.light.intensity = 2800
        light.look(at: .zero, from: SIMD3<Float>(-0.45, 0.85, 0.7), relativeTo: nil)
        anchor.addChild(light)

        let fillLight = PointLight()
        fillLight.light.intensity = 900
        fillLight.position = SIMD3<Float>(0.45, 0.25, 0.65)
        anchor.addChild(fillLight)

        let camera = PerspectiveCamera()
        camera.position = SIMD3<Float>(0, 0.02, 0.62)
        camera.look(at: SIMD3<Float>(0, -0.03, 0), from: camera.position, relativeTo: nil)
        anchor.addChild(camera)

        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        context.coordinator.applyRotation(yaw: yaw, pitch: pitch)
    }

    private func applyMonochromeMaterials(to entity: Entity) {
        if var modelComponent = entity.components[ModelComponent.self] {
            modelComponent.materials = modelComponent.materials.map { _ in
                SimpleMaterial(color: .init(white: 0.82, alpha: 1.0), roughness: 0.62, isMetallic: false)
            }
            entity.components[ModelComponent.self] = modelComponent
        }

        for child in entity.children {
            applyMonochromeMaterials(to: child)
        }
    }

    final class Coordinator: NSObject {
        weak var rootEntity: Entity?
        private var lastAppliedYaw: Float = 0
        private var lastAppliedPitch: Float = 0

        func applyRotation(yaw: Float, pitch: Float) {
            guard let rootEntity else { return }
            let deltaYaw = yaw - lastAppliedYaw
            let deltaPitch = pitch - lastAppliedPitch
            lastAppliedYaw = yaw
            lastAppliedPitch = pitch
            let yawRotation = simd_quatf(angle: deltaYaw, axis: SIMD3<Float>(0, 1, 0))
            let pitchRotation = simd_quatf(angle: deltaPitch, axis: SIMD3<Float>(1, 0, 0))
            let totalDeltaRotation = yawRotation * pitchRotation
            rootEntity.orientation = totalDeltaRotation * rootEntity.orientation
        }
    }
}
