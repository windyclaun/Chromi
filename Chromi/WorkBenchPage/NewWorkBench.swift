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
    
    @State var potionsList: [BallDataType]
    @State var targetList: [PotionTargetDataType]
    
    @State private var isPauseGame: Bool = false
    @State private var fruitYaw: Float = 0
    @State private var fruitPitch: Float = 0
    @State private var lastFruitDrag: CGSize = .zero
    @State private var isFruitFloating = false
    @State private var showSuccessPage = false
    
    init(
        modelName: String,
        potionsList: [BallDataType],
        targetList: [PotionTargetDataType],
        
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
    }
    
    var body: some View {
        ZStack {
            WorkBenchBackground()
            WorkBenchOnly(
                balls: $potionsList,
                targets: $targetList
            )
            WorkBenchTopButton(onBack: onBack, onRestart: onRestart, isPauseGame: $isPauseGame)
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
        .sheet(isPresented: $isPauseGame) {
            PauseMenuView(
//                onBack: {
//                    showSuccessPage = false
//                },
//                onRestart: {
//                    showSuccessPage = false
//                    onRestart()
//                },
//                onNextLevel: {
//                    showSuccessPage = false
//                    onNextLevel()
//                },
//                onMenu: {
//                    showSuccessPage = false
//                    onMenu()
//                },
            )
        }
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


struct Test_PreviewContainer: View {
    @State var potionsList: [BallDataType] = [
        BallDataType(colorName: "red"),
        BallDataType(colorName: "orange"),
        BallDataType(colorName: "red")
    ]
    
    @State var targetList: [PotionTargetDataType] = [
        PotionTargetDataType(colorName: "red"),
        PotionTargetDataType(colorName: "blue")
    ]
    
    var body: some View {
        NewWorkBench(modelName: "Orange",
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
