//
//  WorkBenchView.swift
//  Chromi
//
//  Created by Windy Claudia Napitupulu on 22/07/26.
//

import SwiftUI

struct WorkBenchOnly: View {
    @Binding var balls: [PotionType]
    @Binding var targets: [TargetDataType]
    let modelName: String
    
    @Binding var isLayoutInitialized: Bool
    let isWandUnlocked: Bool
    let showsTutorial: Bool
    let onInitialLayoutCaptured: ([PotionType]) -> Void
    let onWandProgress: (CGFloat) -> Void
    let onWandCast: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            loadBundledImage("reactionSmileNew.PNG")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .clipped()
            WorkBench(
                balls: $balls,
                targets: $targets,
                modelName: modelName,
                isLayoutInitialized: $isLayoutInitialized,
                isWandUnlocked: isWandUnlocked,
                showsTutorial: showsTutorial,
                onInitialLayoutCaptured: onInitialLayoutCaptured,
                onWandProgress: onWandProgress,
                onWandCast: onWandCast
            )
        }
        .ignoresSafeArea()
    }
}

struct WorkBench: View {
    @Binding var balls: [PotionType]
    @Binding var targets: [TargetDataType]
    let modelName: String
    
    @Binding var isLayoutInitialized: Bool
    let isWandUnlocked: Bool
    let showsTutorial: Bool
    let onInitialLayoutCaptured: ([PotionType]) -> Void
    let onWandProgress: (CGFloat) -> Void
    let onWandCast: () -> Void
    @State private var preparedPotionIndices: Set<Int> = []
    @State private var didCaptureInitialLayout = false

    var body: some View {
        ZStack {
            loadBundledImage("table.png")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .clipped()
                .ignoresSafeArea()

            GeometryReader { geometry in
                let tableBounds = CGRect(origin: .zero, size: geometry.size)
                let potionBounds = CGRect(
                    x: tableBounds.minX,
                    y: tableBounds.minY,
                    width: max(WorkBenchPotionLayout.shelfWidth, tableBounds.width - 220),
                    height: tableBounds.height
                )

                ZStack(alignment: .bottomLeading) {
                    HStack(alignment: .center, spacing: 18) {
                        Spacer(minLength: 24)

                        Color.clear
                            .frame(width: WorkBenchPotionLayout.shelfWidth, height: WorkBenchPotionLayout.shelfHeight)

                        HStack(spacing: 24) {
                            ForEach(targets.indices, id: \.self) { index in
                                TargetPotionBox(targetPotion: $targets[index])
                            }
                        }
                        .frame(maxWidth: 360)

                        WandToolView(
                            isUnlocked: isWandUnlocked,
                            onProgress: onWandProgress,
                            onCast: onWandCast
                        )
                        .frame(width: 220, height: 290)

                        Spacer(minLength: 24)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                    if !isLayoutInitialized {
                        HStack {
                            LazyHGrid(
                                rows: Array(
                                    repeating: GridItem(.fixed(WorkBenchPotionLayout.size), spacing: WorkBenchPotionLayout.spacing),
                                    count: WorkBenchPotionLayout.maxRows
                                ),
                                spacing: WorkBenchPotionLayout.spacing
                            ) {
                                ForEach(balls.indices, id: \.self) { index in
                                    GeometryReader { itemGeo in
                                        Color.clear
                                            .onAppear {
                                                DispatchQueue.main.async {
                                                    let localFrame = itemGeo.frame(in: .named("TableSpace"))
                                                    balls[index].position = CGPoint(x: localFrame.minX, y: localFrame.minY)
                                                    balls[index].homePosition = balls[index].position
                                                    preparedPotionIndices.insert(index)

                                                    if preparedPotionIndices.count == balls.count {
                                                        if !didCaptureInitialLayout {
                                                            didCaptureInitialLayout = true
                                                            onInitialLayoutCaptured(balls)
                                                        }
                                                        isLayoutInitialized = true
                                                    }
                                                }
                                            }
                                    }
                                    .frame(width: WorkBenchPotionLayout.size, height: WorkBenchPotionLayout.size)
                                }
                            }
                            .padding(.leading, 36)
                            .frame(width: WorkBenchPotionLayout.shelfWidth, height: WorkBenchPotionLayout.shelfHeight, alignment: .leading)
                            .onChange(of: balls.count) { _, _ in
                                preparedPotionIndices.removeAll()
                                didCaptureInitialLayout = false
                            }

                            Spacer()
                        }
                        .frame(maxHeight: .infinity)
                    } else {
                        ForEach(balls) { ball in
                            InteractiveBallView(
                                ball: ball,
                                allBalls: $balls,
                                targets: $targets,
                                tableBounds: potionBounds
                            )
                        }
                    }

                    if isLayoutInitialized && showsTutorial {
                        WorkbenchTutorialView(modelName: modelName, balls: balls, targets: targets)
                            .allowsHitTesting(false)
                            .transition(.opacity)
                    }
                }
            }
            .coordinateSpace(name: "TableSpace")
            .frame(maxWidth: .infinity, maxHeight: 450)
        }
    }
}

#Preview {
    WorkBenchOnly_PreviewContainer()
}

struct WorkBenchOnly_PreviewContainer: View {
    @State var potionsList: [PotionType] = [
        PotionType(colorName: "red"),
        PotionType(colorName: "yellow"),
        PotionType(colorName: "red")
    ]
    
    @State var targetList: [TargetDataType] = [
        TargetDataType(colorName: "red"),
        TargetDataType(colorName: "blue")
    ]
    
    @State var isLayoutInitialized: Bool = false

    var body: some View {
        WorkBenchOnly(
            balls: $potionsList,
            targets: $targetList,
            modelName: "Apple",
            isLayoutInitialized: $isLayoutInitialized,
            isWandUnlocked: true,
            showsTutorial: true,
            onInitialLayoutCaptured: { _ in },
            onWandProgress: { _ in },
            onWandCast: {}
        )
    }
}
