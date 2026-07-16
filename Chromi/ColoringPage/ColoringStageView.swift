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
    
    var onOpenWorkbench: () -> Void

    var body: some View {
        ZStack {
            VStack(spacing: 6) {
                speechBubble
                    .offset(y: isBubbleFloating ? -8 : 0)
                    .animation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true), value: isBubbleFloating)

                RealityFruitView(modelName: modelName, yaw: fruitYaw, pitch: fruitPitch)
                    .id(modelName)
                    .frame(
                        width: min(geometrySize.width * (isLandscape ? 0.38 : 0.72), 500),
                        height: min(height * 0.72, 470)
                    )
                    .shadow(color: Color.black.opacity(0.22), radius: 20, x: 0, y: 18)
                    .contentShape(Rectangle())
                    .gesture(fruitRotationGesture)
                    .onTapGesture {
                        onOpenWorkbench()
                    }

                HStack(spacing: 7) {
                    Image(systemName: "rotate.3d")
                    Text("Geser ke semua arah untuk memutar")
                }
                .font(.system(size: 13, weight: .black, design: .rounded))
                .foregroundStyle(.white.opacity(0.92))
                .padding(.horizontal, 12)
                .padding(.vertical, 7)
                .background(Color.black.opacity(0.18), in: Capsule())

                Button(action: onOpenWorkbench) {
                    HStack(spacing: 10) {
                        Image(systemName: "paintpalette.fill")
                        Text("Buka Work Bench")
                    }
                    .font(.system(size: 17, weight: .black, design: .rounded))
                    .foregroundStyle(Color(red: 0.34, green: 0.07, blue: 0.68))
                    .padding(.horizontal, 18)
                    .padding(.vertical, 12)
                    .background(
                        LinearGradient(
                            colors: [Color.white, Color(red: 1.0, green: 0.9, blue: 0.34)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        in: Capsule()
                    )
                    .overlay(Capsule().stroke(Color.white.opacity(0.82), lineWidth: 2))
                    .shadow(color: Color.yellow.opacity(0.36), radius: 12, x: 0, y: 6)
                }
                .buttonStyle(LevelButtonStyle())

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
        }
    }

    private var speechBubble: some View {
        HStack(spacing: 8) {
            Image(systemName: "sparkles")
                .font(.system(size: 17, weight: .black))

            Text("Warnai aku dengan sihir warna!")
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

            Text("Ayo mix warna!")
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

    private var fruitRotationGesture: some Gesture {
        DragGesture(minimumDistance: 4)
            .onChanged { value in
                guard !isPaused else { return }

                let deltaX = value.translation.width - lastFruitDrag.width
                let deltaY = value.translation.height - lastFruitDrag.height

                fruitYaw += Float(deltaX) * 0.01
                fruitPitch += Float(deltaY) * 0.01
                lastFruitDrag = value.translation
            }
            .onEnded { _ in
                lastFruitDrag = .zero
            }
    }
}
