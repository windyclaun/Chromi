//
//  ColoringStageView.swift
//  Chromi
//
//  Created by Windy Claudia Napitupulu on 15/07/26.
//

import SwiftUI

struct ColoringStageView: View {
    let modelName: String
    let geometrySize: CGSize
    let height: CGFloat
    let isLandscape: Bool
    let isPaused: Bool
    
    @Binding var fruitYaw: Float
    @Binding var fruitPitch: Float
    @Binding var lastFruitDrag: CGSize
    
    @State private var isBubbleFloating = false
    @State private var isMascotFloating = false
    @State private var isTapPointerMoving = false
    
    var onOpenWorkbench: () -> Void

    var body: some View {
        ZStack {
            VStack(spacing: 6) {
                speechBubble
                    .offset(y: isBubbleFloating ? -8 : 0)
                    .animation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true), value: isBubbleFloating)

                VStack(spacing: 10) {
                    fruitTag

                    ZStack {
                        RotatableFruitModelView(
                            modelName: modelName,
                            yaw: $fruitYaw,
                            pitch: $fruitPitch,
                            lastDrag: $lastFruitDrag,
                            width: min(geometrySize.width * (isLandscape ? 0.38 : 0.72), 500),
                            height: min(height * 0.72, 470),
                            colorProgress: 0,
                            shadowOpacity: 0.22
                        )
                        .onTapGesture {
                            onOpenWorkbench()
                        }

                        tapInstructionPointer
                            .allowsHitTesting(false)
                    }
                }

                TwoFingerRotationHint()

                Button(action: onOpenWorkbench) {
                    ChromiStartButtonLabel(
                        title: "WORK BENCH",
                        systemImage: "paintpalette.fill",
                        width: min(geometrySize.width * (isLandscape ? 0.24 : 0.54), 260),
                        height: 58,
                        fontSize: 19,
                        iconSize: 18
                    )
                }
                .buttonStyle(AnimatedStartButtonStyle())

                objectShadow
            }
            .offset(x: isLandscape ? geometrySize.width * 0.08 : 0, y: isLandscape ? -14 : -20)

            mascotGuide(width: min(geometrySize.width * (isLandscape ? 0.2 : 0.34), 230))
                .offset(
                    x: isLandscape ? -geometrySize.width * 0.34 : -geometrySize.width * 0.27,
                    y: isLandscape ? height * 0.2 : height * 0.18
                )
        }
        .onAppear {
            isBubbleFloating = true
            isMascotFloating = true
            isTapPointerMoving = true
        }
    }

    private var speechBubble: some View {
        HStack(spacing: 8) {
            Image(systemName: "sparkles")
                .font(.system(size: 17, weight: .black))

            Text("Bring my colors back with magic!")
                .font(.system(size: 18, weight: .black, design: .rounded))
                .lineLimit(2)
                .minimumScaleFactor(0.72)
        }
        .foregroundStyle(Color(red: 0.28, green: 0.08, blue: 0.62))
        .padding(.horizontal, 18)
        .padding(.vertical, 12)
        .background(
            LinearGradient(
                colors: [Color.white, Color(red: 1.0, green: 0.92, blue: 0.28)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            in: RoundedRectangle(cornerRadius: 22, style: .continuous)
        )
        .overlay(alignment: .bottom) {
            TrianglePointer()
                .fill(Color(red: 1.0, green: 0.92, blue: 0.28))
                .frame(width: 22, height: 14)
                .offset(y: 12)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(Color.white.opacity(0.72), lineWidth: 2)
        )
        .shadow(color: Color.yellow.opacity(0.42), radius: 16, x: 0, y: 0)
        .shadow(color: Color.black.opacity(0.18), radius: 10, x: 0, y: 6)
    }

    private var fruitTag: some View {
        Text(displayFruitName(for: modelName))
            .font(.system(size: 15, weight: .black, design: .rounded))
            .foregroundStyle(Color(red: 0.25, green: 0.08, blue: 0.58))
            .padding(.horizontal, 14)
            .padding(.vertical, 7)
            .background(Color.white.opacity(0.92), in: Capsule())
            .overlay(Capsule().stroke(Color.purple.opacity(0.24), lineWidth: 2))
            .shadow(color: Color.black.opacity(0.12), radius: 8, x: 0, y: 4)
    }

    private func displayFruitName(for modelName: String) -> String {
        switch modelName {
        case "Lemon1":
            return "Lemon"
        default:
            return modelName
        }
    }

    private func mascotGuide(width: CGFloat) -> some View {
        ZStack(alignment: .topTrailing) {
            loadBundledImage("maskotNew")
                .resizable()
                .scaledToFit()
                .frame(width: width)
                .shadow(color: Color.purple.opacity(0.55), radius: 22, x: 0, y: 0)
                .shadow(color: Color.black.opacity(0.32), radius: 14, x: 0, y: 10)
                .offset(y: isMascotFloating ? -5 : 5)
                .animation(.easeInOut(duration: 2.1).repeatForever(autoreverses: true), value: isMascotFloating)

            Text("Let's mix colors!")
                .font(.system(size: 15, weight: .black, design: .rounded))
                .foregroundStyle(Color(red: 0.32, green: 0.08, blue: 0.68))
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color(red: 1.0, green: 0.88, blue: 0.18), in: Capsule())
                .shadow(color: Color.yellow.opacity(0.45), radius: 10, x: 0, y: 0)
                .offset(x: width * 0.1, y: -12)
        }
    }

    private var objectShadow: some View {
        Ellipse()
            .fill(Color.black.opacity(0.16))
            .frame(width: 200, height: 30)
            .blur(radius: 14)
            .offset(y: 16)
    }

    private var tapInstructionPointer: some View {
        Image(systemName: "hand.point.up.left.fill")
            .font(.system(size: 36, weight: .black))
            .foregroundStyle(.white)
            .shadow(color: Color.black.opacity(0.36), radius: 6, x: 0, y: 3)
            .scaleEffect(isTapPointerMoving ? 0.9 : 1.12)
            .rotationEffect(.degrees(isTapPointerMoving ? -10 : 4))
            .offset(x: isTapPointerMoving ? 42 : 18, y: isTapPointerMoving ? 34 : 8)
            .animation(.easeInOut(duration: 0.82).repeatForever(autoreverses: true), value: isTapPointerMoving)
    }

}
