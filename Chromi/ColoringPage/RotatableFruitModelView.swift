//
//  RotatableFruitModelView.swift
//  Chromi
//
//  Created by Coding Assistant on 21/07/26.
//

import SwiftUI
import UIKit

struct RotatableFruitModelView: View {
    let modelName: String
    @Binding var yaw: Float
    @Binding var pitch: Float
    @Binding var lastDrag: CGSize

    let width: CGFloat
    let height: CGFloat
    var colorProgress: CGFloat = 0
    var shadowOpacity: Double = 0.24

    private var normalizedProgress: CGFloat {
        min(max(colorProgress, 0), 1)
    }

    var body: some View {
        modelContent
            .frame(width: width, height: height)
            .shadow(color: Color.black.opacity(shadowOpacity), radius: 18, x: 0, y: 16)
            .contentShape(Rectangle())
            .overlay {
                TwoFingerFruitRotationView(yaw: $yaw, pitch: $pitch, lastDrag: $lastDrag)
            }
    }

    @ViewBuilder
    private var modelContent: some View {
        if normalizedProgress <= 0.001 {
            RealityFruitView(modelName: modelName, yaw: yaw, pitch: pitch, isMonochrome: true)
                .id("\(modelName)-gray")
        } else if normalizedProgress >= 0.999 {
            RealityFruitView(modelName: modelName, yaw: yaw, pitch: pitch, isMonochrome: false)
                .id("\(modelName)-color")
        } else {
            ZStack {
                RealityFruitView(modelName: modelName, yaw: yaw, pitch: pitch, isMonochrome: true)
                    .id("\(modelName)-gray")
                    .opacity(1 - normalizedProgress)

                RealityFruitView(modelName: modelName, yaw: yaw, pitch: pitch, isMonochrome: false)
                    .id("\(modelName)-color")
                    .opacity(normalizedProgress)
            }
        }
    }
}

struct TwoFingerRotationHint: View {
    var body: some View {
        HStack(spacing: 7) {
            Image(systemName: "hand.draw.fill")
            Text("Use two fingers to rotate")
        }
        .font(.system(size: 13, weight: .black, design: .rounded))
        .foregroundStyle(.white.opacity(0.94))
        .padding(.horizontal, 12)
        .padding(.vertical, 7)
        .background(Color.black.opacity(0.18), in: Capsule())
    }
}

struct TwoFingerFruitRotationView: UIViewRepresentable {
    @Binding var yaw: Float
    @Binding var pitch: Float
    @Binding var lastDrag: CGSize

    func makeCoordinator() -> Coordinator {
        Coordinator(yaw: $yaw, pitch: $pitch, lastDrag: $lastDrag)
    }

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear

        let panGesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handlePan(_:)))
        panGesture.minimumNumberOfTouches = 2
        panGesture.maximumNumberOfTouches = 2
        view.addGestureRecognizer(panGesture)

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}

    final class Coordinator: NSObject {
        private var yaw: Binding<Float>
        private var pitch: Binding<Float>
        private var lastDrag: Binding<CGSize>

        init(yaw: Binding<Float>, pitch: Binding<Float>, lastDrag: Binding<CGSize>) {
            self.yaw = yaw
            self.pitch = pitch
            self.lastDrag = lastDrag
        }

        @objc func handlePan(_ recognizer: UIPanGestureRecognizer) {
            let translation = recognizer.translation(in: recognizer.view)
            let currentDrag = CGSize(width: translation.x, height: translation.y)

            switch recognizer.state {
            case .began, .changed:
                let deltaX = currentDrag.width - lastDrag.wrappedValue.width
                let deltaY = currentDrag.height - lastDrag.wrappedValue.height
                yaw.wrappedValue += Float(deltaX) * 0.01
                pitch.wrappedValue += Float(deltaY) * 0.01
                lastDrag.wrappedValue = currentDrag
            default:
                lastDrag.wrappedValue = .zero
            }
        }
    }
}
