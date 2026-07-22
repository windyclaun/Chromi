//
//  WorkBenchOnly.swift
//  Chromi
//
//  Created by ALBERTO YOHANES WIDAGDO on 16/07/26.
//

import SwiftUI

struct PotionType: Identifiable, Equatable {
    let id = UUID()
    var colorName: String
    var isUnlocked: Bool = true
    var position: CGPoint = .zero
    var homePosition: CGPoint = .zero
}

struct TargetDataType: Identifiable {
    let id = UUID()
    var colorName: String
    var isMatched: Bool = false
    var globalFrame: CGRect = .zero
}

struct WorkbenchLevelConfig {
    let targets: [String]
    let unlockedPotions: [String]
    let lockedPotions: [String]
}

enum PotionAssetCatalog {
    static let primaryColorNames = ["red", "yellow", "blue"]
    static let secondaryColorNames = ["orange", "purple", "green", "brown"]
    static let modifierColorNames = ["min_red", "min_blue", "min_yellow", "min_green", "min_orange", "min_purple"]

    static var allColorNames: [String] {
        primaryColorNames + secondaryColorNames + modifierColorNames
    }

    static func potions(for modelName: String) -> [PotionType] {
        let config = WorkbenchLevelRecipe.config(for: modelName)
        let unlockedSet = Set(config.unlockedPotions)
        let orderedNames = unique(config.unlockedPotions + config.lockedPotions)

        return orderedNames.map { colorName in
            PotionType(colorName: colorName, isUnlocked: unlockedSet.contains(colorName))
        }
    }

    static func imageName(for colorName: String) -> String {
        "ColorPotion/\(colorName).PNG"
    }

    static func displayName(for colorName: String) -> String {
        switch colorName {
        case "red": return "Red"
        case "yellow": return "Yellow"
        case "blue": return "Blue"
        case "orange": return "Orange"
        case "purple": return "Purple"
        case "green": return "Green"
        case "brown": return "Brown"
        case "min_red": return "-Red"
        case "min_blue": return "-Blue"
        case "min_yellow": return "-Yellow"
        case "min_green": return "-Green"
        case "min_orange": return "-Orange"
        case "min_purple": return "-Purple"
        default: return colorName
        }
    }

    static func tint(for colorName: String) -> Color {
        switch colorName {
        case "red", "min_red": return Color(red: 0.96, green: 0.18, blue: 0.26)
        case "yellow", "min_yellow": return Color(red: 1.0, green: 0.82, blue: 0.12)
        case "blue", "min_blue": return Color(red: 0.22, green: 0.48, blue: 1.0)
        case "orange", "min_orange": return Color(red: 1.0, green: 0.48, blue: 0.08)
        case "purple", "min_purple": return Color(red: 0.62, green: 0.28, blue: 0.92)
        case "green", "min_green": return Color(red: 0.18, green: 0.72, blue: 0.32)
        case "brown": return Color(red: 0.44, green: 0.24, blue: 0.1)
        default: return .gray
        }
    }

    private static func unique(_ names: [String]) -> [String] {
        var seen = Set<String>()
        return names.filter { seen.insert($0).inserted }
    }
}

enum WorkBenchPotionLayout {
    static let size: CGFloat = 104
    static let spacing: CGFloat = 14
    static let maxRows = 3
    static let shelfWidth: CGFloat = 510
    static let shelfHeight: CGFloat = size * CGFloat(maxRows) + spacing * CGFloat(maxRows - 1)
}

enum WorkbenchLevelRecipe {
    static let levelOnePlaceholder = WorkbenchLevelConfig(
        targets: ["red"],
        unlockedPotions: ["red", "yellow", "blue"],
        lockedPotions: ["orange", "purple", "green", "brown", "min_red", "min_blue", "min_yellow"]
    )

    static func config(for modelName: String) -> WorkbenchLevelConfig {
        switch modelName {
        case "Apple", "Placeholder8", "Placeholder9", "Placeholder10":
            return levelOnePlaceholder
        case "Watermelon":
            return WorkbenchLevelConfig(
                targets: ["green"],
                unlockedPotions: ["red", "yellow", "blue"],
                lockedPotions: ["orange", "purple", "green", "brown", "min_red", "min_blue", "min_yellow"]
            )
        case "Orange":
            return WorkbenchLevelConfig(
                targets: ["orange", "green"],
                unlockedPotions: ["red", "yellow", "blue", "green"],
                lockedPotions: ["purple", "orange", "brown", "min_red", "min_blue", "min_yellow"]
            )
        case "Eggplant":
            return WorkbenchLevelConfig(
                targets: ["purple", "green"],
                unlockedPotions: ["red", "yellow", "blue", "green", "orange"],
                lockedPotions: ["purple", "brown", "min_red", "min_blue", "min_yellow"]
            )
        case "Lemon1":
            return WorkbenchLevelConfig(
                targets: ["yellow"],
                unlockedPotions: ["orange", "purple", "blue", "green", "min_red", "min_blue", "min_yellow"],
                lockedPotions: ["red", "yellow", "brown"]
            )
        case "Coconut":
            return WorkbenchLevelConfig(
                targets: ["brown"],
                unlockedPotions: ["red", "yellow", "blue", "orange", "purple", "green", "min_red", "min_blue", "min_yellow"],
                lockedPotions: ["brown"]
            )
        case "Avocado":
            return WorkbenchLevelConfig(
                targets: ["green"],
                unlockedPotions: ["purple", "yellow", "blue", "min_red", "min_blue", "min_yellow"],
                lockedPotions: ["red", "orange", "green", "brown"]
            )
        default:
            return levelOnePlaceholder
        }
    }

    static func targets(for modelName: String) -> [TargetDataType] {
        config(for: modelName).targets.map { TargetDataType(colorName: $0) }
    }
}

struct WorkBenchOnly: View {
    @Binding var balls: [PotionType]
    @Binding var targets: [TargetDataType]
    let modelName: String
    
    @Binding var isLayoutInitialized: Bool
    let isWandUnlocked: Bool
    let showsTutorial: Bool
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
    let onWandProgress: (CGFloat) -> Void
    let onWandCast: () -> Void
    @State private var preparedPotionIndices: Set<Int> = []

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

                    if showsTutorial {
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

struct WorkbenchTutorialView: View {
    let modelName: String
    let balls: [PotionType]
    let targets: [TargetDataType]

    @State private var animate = false

    private enum TutorialMode {
        case mix
        case target
        case hidden
    }

    private var tutorialMode: TutorialMode {
        switch modelName {
        case "Apple":
            return balls.contains(where: { $0.colorName == "green" && $0.isUnlocked }) ? .target : .mix
        case "Lemon1", "Avocado":
            return balls.contains(where: { $0.colorName == "red" && $0.isUnlocked }) ? .hidden : .mix
        default:
            return .hidden
        }
    }

    private var mixSourceColor: String {
        modelName == "Lemon1" || modelName == "Avocado" ? "min_blue" : "blue"
    }

    private var mixDestinationColor: String {
        modelName == "Lemon1" || modelName == "Avocado" ? "purple" : "yellow"
    }

    private var targetPrompt: String {
        modelName == "Avocado" ? "Now drag Red to the target." : "Now drag Red to the target."
    }

    var body: some View {
        GeometryReader { geometry in
            let sourcePosition = position(for: mixSourceColor, in: geometry.size)
            let destinationPosition = position(for: mixDestinationColor, in: geometry.size)
            let redPosition = position(for: "red", in: geometry.size)
            let targetPosition = targets.first?.globalFrame.centerPoint ?? CGPoint(x: geometry.size.width * 0.68, y: geometry.size.height * 0.58)

            if tutorialMode != .hidden {
                ZStack {
                    tutorialBubble
                        .position(x: geometry.size.width * 0.5, y: geometry.size.height * 0.16)

                    switch tutorialMode {
                    case .mix:
                        tutorialArrow(from: sourcePosition, to: destinationPosition)

                        PotionImageView(colorName: mixSourceColor)
                            .frame(width: 82, height: 82)
                            .scaleEffect(animate ? 1.08 : 0.96)
                            .rotationEffect(.degrees(animate ? 8 : -8))
                            .position(animate ? destinationPosition : sourcePosition)
                            .shadow(color: Color.white.opacity(0.55), radius: 14, x: 0, y: 0)
                            .animation(.easeInOut(duration: 0.95).repeatForever(autoreverses: true), value: animate)

                    case .target:
                        tutorialArrow(from: redPosition, to: targetPosition)

                        PotionImageView(colorName: "red")
                            .frame(width: 82, height: 82)
                            .scaleEffect(animate ? 1.08 : 0.96)
                            .rotationEffect(.degrees(animate ? 8 : -8))
                            .position(animate ? targetPosition : redPosition)
                            .shadow(color: Color.white.opacity(0.55), radius: 14, x: 0, y: 0)
                            .animation(.easeInOut(duration: 0.95).repeatForever(autoreverses: true), value: animate)

                    case .hidden:
                        EmptyView()
                    }
                }
            }
        }
        .onAppear {
            animate = true
        }
        .onChange(of: tutorialModeKey) { _, _ in
            animate = false
            DispatchQueue.main.async {
                animate = true
            }
        }
    }

    private var tutorialBubble: some View {
        VStack(spacing: 3) {
            Text("Tutorial")
                .font(.system(size: 13, weight: .black, design: .rounded))
            Text(tutorialCopy)
                .font(.system(size: 12, weight: .heavy, design: .rounded))
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
        .foregroundStyle(Color(red: 0.25, green: 0.08, blue: 0.58))
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(Color.white.opacity(0.92), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.purple.opacity(0.25), lineWidth: 2)
        )
        .frame(width: 280)
        .shadow(color: Color.black.opacity(0.16), radius: 10, x: 0, y: 5)
    }

    private var tutorialCopy: String {
        switch tutorialMode {
        case .mix:
            if modelName == "Lemon1" || modelName == "Avocado" {
                return "Drag Minus Blue to Purple."
            }
            return "Drag Blue to Yellow."
        case .target:
            return targetPrompt
        case .hidden:
            return ""
        }
    }

    private var tutorialModeKey: String {
        switch tutorialMode {
        case .mix: return "mix"
        case .target: return "target"
        case .hidden: return "hidden"
        }
    }

    private func position(for colorName: String, in size: CGSize) -> CGPoint {
        if let ball = balls.first(where: { $0.colorName == colorName }) {
            return CGPoint(
                x: ball.position.x + WorkBenchPotionLayout.size / 2,
                y: ball.position.y + WorkBenchPotionLayout.size / 2
            )
        }

        return CGPoint(x: size.width * 0.18, y: size.height * 0.62)
    }

    private func tutorialArrow(from start: CGPoint, to end: CGPoint) -> some View {
        Image(systemName: "arrow.right")
            .font(.system(size: 26, weight: .black))
            .foregroundStyle(.white)
            .rotationEffect(.radians(Double(atan2(end.y - start.y, end.x - start.x))))
            .shadow(color: Color.black.opacity(0.35), radius: 5, x: 0, y: 2)
            .position(x: (start.x + end.x) / 2, y: (start.y + end.y) / 2)
    }
}

private extension CGRect {
    var centerPoint: CGPoint {
        CGPoint(x: midX, y: midY)
    }
}

struct TargetPotionBox: View {
    @Binding var targetPotion: TargetDataType
    
    var body: some View {
        ZStack {
            loadBundledImage("potionFrame.png")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 180)
                .clipped()

            PotionImageView(colorName: targetPotion.colorName)
                .frame(width: 140, height: 140)
                .opacity(targetPotion.isMatched ? 1.0 : 0.34)
                .saturation(targetPotion.isMatched ? 1.0 : 0.25)
        }
        .background(
            GeometryReader { geo in
                Color.clear
                    .onAppear {
                        targetPotion.globalFrame = geo.frame(in: .named("TableSpace"))
                    }
                    .onChange(of: geo.frame(in: .named("TableSpace"))) { _, newFrame in
                        targetPotion.globalFrame = newFrame
                    }
            }
        )
    }
}

struct WandToolView: View {
    let isUnlocked: Bool
    let onProgress: (CGFloat) -> Void
    let onCast: () -> Void

    @State private var dragOffset: CGSize = .zero
    @State private var isCasting = false

    var body: some View {
        VStack(spacing: 8) {
            Text(isUnlocked ? "Magic Wand" : "Locked")
                .font(.system(size: 13, weight: .black, design: .rounded))
                .foregroundStyle(.white.opacity(isUnlocked ? 0.96 : 0.72))
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.black.opacity(0.2), in: Capsule())

            ZStack {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.white.opacity(isUnlocked ? 0.18 : 0.09))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(Color.white.opacity(isUnlocked ? 0.42 : 0.18), lineWidth: 2)
                    )

                wandImage

                if !isUnlocked {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 32, weight: .black))
                        .foregroundStyle(.white)
                        .padding(18)
                        .background(Color.black.opacity(0.36), in: Circle())
                }
            }
        }
    }

    private var wandGesture: some Gesture {
        DragGesture(minimumDistance: 6)
            .onChanged { value in
                let limitedX = min(max(value.translation.width, -360), 42)
                let limitedY = min(max(value.translation.height, -520), 28)
                let upwardProgress = abs(min(limitedY, 0)) / 430
                let leftProgress = abs(min(limitedX, 0)) / 300
                let progress = min(max((upwardProgress * 0.74) + (leftProgress * 0.26), 0), 1)
                dragOffset = CGSize(width: limitedX, height: limitedY)
                isCasting = progress > 0.22
                onProgress(progress)
            }
            .onEnded { value in
                let didCast = value.translation.height < -380 || (value.translation.height < -280 && value.translation.width < -180)
                withAnimation(.spring(response: 0.34, dampingFraction: 0.72)) {
                    dragOffset = .zero
                    isCasting = false
                }

                if didCast {
                    SoundEffectPlayer.shared.play(named: "mixkit-fairy-magic-sparkle-871", fileExtension: "wav")
                    onProgress(1)
                    onCast()
                } else {
                    onProgress(0)
                }
            }
    }

    @ViewBuilder
    private var wandImage: some View {
        let image = loadBundledImage("tongkat.png")
            .resizable()
            .scaledToFit()
            .frame(width: 130, height: 174)
            .rotationEffect(.degrees(isCasting ? -34 : -10))
            .offset(dragOffset)
            .opacity(isUnlocked ? 1.0 : 0.38)
            .saturation(isUnlocked ? 1.0 : 0.0)
            .shadow(color: Color.yellow.opacity(isUnlocked ? 0.55 : 0.0), radius: 16, x: 0, y: 0)

        if isUnlocked {
            image.gesture(wandGesture)
        } else {
            image
        }
    }
}

struct PotionImageView: View {
    let colorName: String

    var body: some View {
        if let imageName = resolvedPotionImageName {
            loadBundledImage(imageName)
                .resizable()
                .scaledToFit()
        } else {
            potionFallback
        }
    }

    private var resolvedPotionImageName: String? {
        [
            PotionAssetCatalog.imageName(for: colorName),
            "\(colorName).PNG",
            "Assets/ColorPotion/\(colorName).PNG",
            "potions/\(colorName).png"
        ].first { bundledUIImage(named: $0) != nil }
    }

    private var potionFallback: some View {
        let tint = PotionAssetCatalog.tint(for: colorName)

        return ZStack {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [tint.opacity(0.92), tint.opacity(0.58)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(Color.white.opacity(0.42), lineWidth: 3)
                )

            VStack(spacing: 3) {
                Image(systemName: "minus.circle.fill")
                    .font(.system(size: 25, weight: .black))
                Text(PotionAssetCatalog.displayName(for: colorName))
                    .font(.system(size: 10, weight: .black, design: .rounded))
                    .lineLimit(1)
                    .minimumScaleFactor(0.72)
            }
            .foregroundStyle(.white)
            .shadow(color: Color.black.opacity(0.22), radius: 2, x: 0, y: 1)
            .padding(.horizontal, 6)
        }
    }
}

struct InteractiveBallView: View {
    var ball: PotionType
    @Binding var allBalls: [PotionType]
    @Binding var targets: [TargetDataType]
    let tableBounds: CGRect
    
    @State private var dragOffset: CGSize = .zero

    private let potionSize = WorkBenchPotionLayout.size

    var body: some View {
        potionContent
            .position(x: ball.position.x + potionSize / 2, y: ball.position.y + potionSize / 2)
            .offset(dragOffset)
    }

    @ViewBuilder
    private var potionContent: some View {
        let content = PotionImageView(colorName: ball.colorName)
            .frame(width: potionSize, height: potionSize)
            .opacity(ball.isUnlocked ? 1.0 : 0.34)
            .saturation(ball.isUnlocked ? 1.0 : 0.08)
            .overlay(alignment: .topTrailing) {
                if !ball.isUnlocked {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 13, weight: .black))
                        .foregroundStyle(.white)
                        .padding(7)
                        .background(Color.black.opacity(0.42), in: Circle())
                        .offset(x: -4, y: 4)
                }
            }
            .shadow(color: Color.black.opacity(ball.isUnlocked ? 0.24 : 0.12), radius: 8, x: 0, y: 5)

        if ball.isUnlocked {
            content.gesture(dragGesture)
        } else {
            content
        }
    }

    private var dragGesture: some Gesture {
        DragGesture(coordinateSpace: .named("TableSpace"))
            .onChanged { gesture in
                let proposedPosition = CGPoint(
                    x: ball.position.x + gesture.translation.width,
                    y: ball.position.y + gesture.translation.height
                )
                let clampedPosition = clampedPotionPosition(proposedPosition)

                dragOffset = CGSize(
                    width: clampedPosition.x - ball.position.x,
                    height: clampedPosition.y - ball.position.y
                )
            }
            .onEnded { gesture in
                if let index = allBalls.firstIndex(where: { $0.id == ball.id }) {
                    let proposedPosition = CGPoint(
                        x: allBalls[index].position.x + gesture.translation.width,
                        y: allBalls[index].position.y + gesture.translation.height
                    )
                    let finalPosition = clampedPotionPosition(proposedPosition)

                    allBalls[index].position = finalPosition
                    dragOffset = .zero

                    if checkTargetDrop(at: finalPosition, currentBall: allBalls[index], currentIndex: index) {
                        return
                    }

                    checkBallMerge(for: allBalls[index], currentIndex: index)
                }
            }
    }

    private func clampedPotionPosition(_ position: CGPoint) -> CGPoint {
        CGPoint(
            x: min(max(position.x, tableBounds.minX), tableBounds.maxX - potionSize),
            y: min(max(position.y, tableBounds.minY), tableBounds.maxY - potionSize)
        )
    }
    
    // Logika Mendeteksi apakah Bola dilepas di atas Target Potion Box
    private func checkTargetDrop(at dropPoint: CGPoint, currentBall: PotionType, currentIndex: Int) -> Bool {
        // Titik tengah bola saat di-drop
        let ballCenter = CGPoint(x: dropPoint.x + potionSize / 2, y: dropPoint.y + potionSize / 2)
        
        for i in targets.indices {
            // Periksa apakah titik tengah bola masuk ke dalam area persegi Target Potion Box
            if targets[i].globalFrame.contains(ballCenter) {
                // Periksa kesamaan warna antara bola dan target
                if targets[i].colorName == currentBall.colorName {
                    SoundEffectPlayer.shared.playColor(named: currentBall.colorName)
                    targets[i].isMatched = true // Ubah opacity ramuan target menjadi 1
                    allBalls.remove(at: currentIndex) // Hapus bola dari meja
                    return true
                }
            }
        }
        return false
    }
    
    // Logika Pencampuran Antar Bola (Merah + Biru = Ungu)
    private func checkBallMerge(for activeBall: PotionType, currentIndex: Int) {
        let mergeThreshold: CGFloat = 50.0

        for index in allBalls.indices {
            if index == currentIndex { continue }

            let targetBall = allBalls[index]
            guard targetBall.isUnlocked else { continue }

            let distance = sqrt(pow(activeBall.position.x - targetBall.position.x, 2) + pow(activeBall.position.y - targetBall.position.y, 2))
            guard distance < mergeThreshold else { continue }

            if let resultColor = mixedColor(activeBall.colorName, targetBall.colorName) {
                addMixedPotion(
                    colorName: resultColor,
                    from: currentIndex,
                    and: index
                )
                break
            }
        }
    }

    private func addMixedPotion(colorName: String, from firstIndex: Int, and secondIndex: Int) {
        if let lockedIndex = allBalls.firstIndex(where: { $0.colorName == colorName && !$0.isUnlocked }) {
            SoundEffectPlayer.shared.playColor(named: colorName)
            allBalls[lockedIndex].isUnlocked = true
            allBalls[firstIndex].position = allBalls[firstIndex].homePosition
            allBalls[secondIndex].position = allBalls[secondIndex].homePosition
            return
        }

        if allBalls.contains(where: { $0.colorName == colorName && $0.isUnlocked }) {
            allBalls[firstIndex].position = allBalls[firstIndex].homePosition
            allBalls[secondIndex].position = allBalls[secondIndex].homePosition
            return
        }

        let firstHome = allBalls[firstIndex].homePosition
        let secondHome = allBalls[secondIndex].homePosition
        let resultPosition = CGPoint(
            x: (firstHome.x + secondHome.x) / 2,
            y: (firstHome.y + secondHome.y) / 2
        )

        SoundEffectPlayer.shared.playColor(named: colorName)
        allBalls[firstIndex].position = firstHome
        allBalls[secondIndex].position = secondHome
        allBalls.append(PotionType(colorName: colorName, isUnlocked: true, position: resultPosition, homePosition: resultPosition))
    }

    private func mixedColor(_ colorA: String, _ colorB: String) -> String? {
        let pair = Set([colorA, colorB])

        switch pair {
        case Set(["red", "blue"]):
            return "purple"
        case Set(["red", "yellow"]):
            return "orange"
        case Set(["blue", "yellow"]):
            return "green"
        case Set(["purple", "min_red"]):
            return "blue"
        case Set(["purple", "min_blue"]):
            return "red"
        case Set(["orange", "min_red"]):
            return "yellow"
        case Set(["orange", "min_yellow"]):
            return "red"
        case Set(["green", "min_blue"]):
            return "yellow"
        case Set(["green", "min_yellow"]):
            return "blue"
        default:
            if shouldBecomeBrown(colorA, colorB) {
                return "brown"
            }
            return nil
        }
    }

    private func shouldBecomeBrown(_ colorA: String, _ colorB: String) -> Bool {
        let normalColors = Set(PotionAssetCatalog.primaryColorNames + PotionAssetCatalog.secondaryColorNames.filter { $0 != "brown" })
        return normalColors.contains(colorA) && normalColors.contains(colorB)
    }
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
            onWandProgress: { _ in },
            onWandCast: {}
        )
    }
}

#Preview {
    WorkBenchOnly_PreviewContainer()
}
