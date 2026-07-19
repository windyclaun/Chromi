//
//  NewWorkBench.swift
//  Chromi
//
//  Created by ALBERTO YOHANES WIDAGDO on 16/07/26.
//

import SwiftUI

struct NewWorkBench: View {
    let modelName: String
    
    let onLevelCompleted: () -> Void
    let onRestart: () -> Void
    let onNextLevel: () -> Void
    let onMenu: () -> Void
    let onBack: () -> Void
    
    @State var potionsList: [PotionType]
    @State var targetList: [TargetDataType]
    
    private let initialBalls: [PotionType]
    private let initialTargets: [TargetDataType]
    
    @State private var isPauseGame: Bool = false
    @State private var fruitYaw: Float = 0
    @State private var fruitPitch: Float = 0
    @State private var lastFruitDrag: CGSize = .zero
    @State private var isFruitFloating = false
    @State private var showSuccessPage = false
    @State private var isReset = false

    init(
        modelName: String,
        potionsList: [PotionType],
        targetList: [TargetDataType],
        
        onLevelCompleted: @escaping () -> Void = {},
        onRestart: @escaping () -> Void,
        onNextLevel: @escaping () -> Void,
        onMenu: @escaping () -> Void,
        onBack: @escaping () -> Void
    ) {
        self.modelName = modelName
        self.onLevelCompleted = onLevelCompleted
        self.onRestart = onRestart
        self.onNextLevel = onNextLevel
        self.onMenu = onMenu
        self.onBack = onBack
        
        self._potionsList = State(initialValue: potionsList)
        self._targetList = State(initialValue: targetList)
        
        self.initialBalls = potionsList
        self.initialTargets = targetList
    }
    
    var body: some View {
        ZStack {
            WorkBenchBackground()
            WorkBenchOnly(
                balls: $potionsList,
                targets: $targetList,
                isLayoutInitialized: $isReset
            )
            FruitModelView(
                modelName: modelName,
                fruitYaw: $fruitYaw,
                fruitPitch: $fruitPitch,
                lastFruitDrag: $lastFruitDrag,
                isFruitFloating: $isFruitFloating
            )
            
            WorkBenchTopButton(onBack: onBack, onRestart: resetGameLevel, isPauseGame: $isPauseGame)
                .zIndex(10)
        }
        .onAppear {
            isFruitFloating = true
        }
        .onChange(of: targetList.map(\.isMatched)) { _, matchedStates in
            guard !matchedStates.isEmpty, matchedStates.allSatisfy({ $0 }) else { return }
            showSuccessPage = true
        }
        .fullScreenCover(isPresented: $showSuccessPage) {
            SuccessPageView(
                modelName: modelName,
                onLevelCompleted: {
                    onLevelCompleted()
                },
                onBack: {
                    showSuccessPage = false
                },
                onRestart: {
                    showSuccessPage = false
                    resetGameLevel()
                    onRestart()
                },
                onNextLevel: {
                    showSuccessPage = false
                    onNextLevel()
                },
                onMenu: {
                    showSuccessPage = false
                    onMenu()
                },
            )
        }
        .fullScreenCover(isPresented: $isPauseGame) {
            PauseMenuView(
                onMainMenu: {
                    isPauseGame = false
                    onMenu()
                },
                onRestart: {
                    resetGameLevel()
                    isPauseGame = false
                    onRestart()
                },
                onResume: {
                    isPauseGame = false
                }
            )
        }
    }
    
    private func resetGameLevel() {
        self.potionsList = initialBalls.map { PotionType(colorName: $0.colorName, isUnlocked: $0.isUnlocked, position: .zero) }
        
        self.targetList = initialTargets.map { TargetDataType(colorName: $0.colorName, isMatched: false, globalFrame: .zero) }
        
        self.isReset = false
    }

}

struct WorkBenchBackground: View {
    var body: some View {
        VStack{
            loadBundledImage("bg_workbenchNew.jpeg")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .clipped()
                .ignoresSafeArea()
            Spacer()
        }

        LinearGradient(
            colors: [
                Color.black.opacity(0.3),
                Color.clear,
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
}

struct WorkBenchTopButton: View {
    let onBack: () -> Void
    let onRestart: () -> Void
    
    @Binding var isPauseGame: Bool
    
    var body: some View {
        VStack{
            HStack{
                //Back Button
                WorkBenchButton(symbolName: "chevron.left", title: "Back"){onBack()}
                .padding(.horizontal, 24)

                Spacer(minLength: 0)
                
                // Restart Button
                WorkBenchButton(symbolName: "arrow.clockwise"){onRestart()}
                
                // Pause Button
                WorkBenchButton(symbolName: "pause.fill"){
                    isPauseGame = true
                    
                }
                .padding(.horizontal, 24)
            }
            Spacer()
        }
    }
    
}

struct WorkBenchButton: View {
    let symbolName: String
    let title: String?
    let action: () -> Void
    
    // Custom initializer to make the title parameter optional and default to nil
    init(symbolName: String, title: String? = nil, action: @escaping () -> Void) {
        self.symbolName = symbolName
        self.title = title
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: "\(symbolName)")
                
                if let title = title {
                    Text(title)
                }
                
            }
            .font(.system(size: 16, weight: .heavy, design: .rounded))
            .foregroundStyle(.white)
            .padding(.horizontal, 18)
            .padding(.vertical, 12)
            .background(
                LinearGradient(
                    colors: [Color(red: 0.72, green: 0.36, blue: 1.0), Color(red: 0.35, green: 0.14, blue: 0.76)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                in: Capsule()
            )
            .overlay(Capsule().stroke(Color.white.opacity(0.42), lineWidth: 2))
            .shadow(color: Color.purple.opacity(0.45), radius: 14, x: 0, y: 8)
        }
        .buttonStyle(LevelButtonStyle())
    }
}

struct FruitModelView: View {
    var modelName: String
    
    @Binding var fruitYaw: Float
    @Binding var fruitPitch: Float
    @Binding var lastFruitDrag: CGSize
    @Binding var isFruitFloating: Bool
    
    var body: some View {
        GeometryReader { geometry in
            let isLandscape = geometry.size.width > geometry.size.height
            let fruitHeightSize = geometry.size.height * (isLandscape ? 0.38 : 0.4)
            let topPadding = fruitHeightSize * 0.08
            
            VStack(spacing: 0) {
                RealityFruitView(modelName: modelName, yaw: fruitYaw, pitch: fruitPitch)
                    .id(modelName)
                    .frame(width: 500, height: fruitHeightSize)
                    .shadow(color: Color.black.opacity(0.24), radius: 18, x: 0, y: 16)
                    .contentShape(Rectangle())
                    .gesture(fruitRotationGesture())
                    .padding(.top, topPadding)
                
                HStack(spacing: 7) {
                    Image(systemName: "rotate.3d")
                    Text("Geser ke semua arah untuk memutar")
                }
                .font(.system(size: 13, weight: .black, design: .rounded))
                .foregroundStyle(.white.opacity(0.94))
                .padding(.horizontal, 12)
                .padding(.vertical, 7)
                .background(Color.black.opacity(0.18), in: Capsule())
                
                Spacer()
            }
            .offset(y: isFruitFloating ? -6 : 0)
            .animation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true), value: isFruitFloating)
            .frame(maxWidth: .infinity, maxHeight: fruitHeightSize)
            .padding(.top, 6)
        }
        .ignoresSafeArea()
        .onAppear {
            isFruitFloating = true
        }

    }
    
    private func fruitRotationGesture() -> some Gesture {
        DragGesture(minimumDistance: 4)
            .onChanged { value in
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

struct Test_PreviewContainer: View {
    @State var potionsList: [PotionType] = [
        PotionType(colorName: "red"),
        PotionType(colorName: "orange"),
        PotionType(colorName: "red")
    ]
    
    @State var targetList: [TargetDataType] = [
        TargetDataType(colorName: "red"),
        TargetDataType(colorName: "blue")
    ]
    
    var body: some View {
        NewWorkBench(modelName: "Avocado",
                     potionsList: potionsList,
                     targetList: targetList,
                     onRestart: {},
                     onNextLevel: {},
                     onMenu: {},
                     onBack: {}
        )
    }
}

#Preview {
    Test_PreviewContainer()
}
