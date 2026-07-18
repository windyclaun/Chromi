//
//  WorkBenchOnly.swift
//  Chromi
//
//  Created by ALBERTO YOHANES WIDAGDO on 16/07/26.
//

import SwiftUI

struct PotionType: Identifiable, Equatable {
    let id = UUID()
    var colorName: String // "red", "blue", atau "purple"
    var position: CGPoint = .zero
}

struct TargetDataType: Identifiable {
    let id = UUID()
    var colorName: String // "red" atau "blue"
    var isMatched: Bool = false
    var globalFrame: CGRect = .zero // Menyimpan area deteksi kotak ramuan di layar
}

struct WorkBenchOnly: View {
    @Binding var balls: [PotionType]
    @Binding var targets: [TargetDataType]
    
    @Binding var isLayoutInitialized: Bool
    
    var body: some View {
        VStack (spacing: 0){
            Spacer()
            loadBundledImage("reactionSmileNew.PNG")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .clipped()
            WorkBench(balls: $balls, targets: $targets, isLayoutInitialized: $isLayoutInitialized)
        }
        .ignoresSafeArea()
    }
}

struct WorkBench: View {
    @Binding var balls: [PotionType]
    @Binding var targets: [TargetDataType]
    
    @Binding var isLayoutInitialized: Bool
    
    var body: some View {
        ZStack {
            loadBundledImage("table.png")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .clipped()
                .ignoresSafeArea()
            
            GeometryReader { viewGeo in
                ZStack(alignment: .bottomLeading) {
                    
                    // KANAN: Kotak Target Potion
                    HStack(spacing: 0) {
                        Spacer()
                        HStack(spacing: 24) {
                            ForEach(targets.indices, id: \.self) { index in
                                TargetPotionBox(targetPotion: $targets[index])
                                
                            }
                        }
                        .frame(maxWidth: 500)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    // KIRI: Inisialisasi Posisi Awal Bola (Hanya sekali saat muncul)
                    if !isLayoutInitialized {
                        HStack {
                            VStack(spacing: 15) {
                                ForEach(balls.indices, id: \.self) { index in
                                    GeometryReader { itemGeo in
                                        Color.clear
                                            .onAppear {
                                                let localFrame = itemGeo.frame(in: .named("TableSpace"))
                                                balls[index].position = CGPoint(x: localFrame.minX, y: localFrame.minY)
                                                
                                                if index == balls.count - 1 {
                                                    isLayoutInitialized = true
                                                }
                                            }
                                    }
                                    .frame(width: 70, height: 70)
                                }
                            }
                            .padding(.leading, 40) // Memastikan letak bola ada di sisi kiri meja
                            Spacer()
                        }
                        .frame(maxHeight: .infinity)
                    } else {
                        // Lapisan Utama Interaksi Bola (Sandbox Bebas)
                        ForEach(balls) { ball in
                            InteractiveBallView(ball: ball, allBalls: $balls, targets: $targets)
                        }
                    }
                }
            }
            .coordinateSpace(name: "TableSpace")
            .frame(maxWidth: .infinity, maxHeight: 450)
            
        }
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
            
            //Target Potion
            loadBundledImage("\(targetPotion.colorName)")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 140)
                .clipped()
                .opacity(targetPotion.isMatched ? 1.0 : 0.4)
        }
        .background(
            // Membaca posisi absolut kotak ramuan di layar dan merekamnya ke struktur data
            GeometryReader { geo in
                Color.clear
                    .onAppear {
                        targetPotion.globalFrame = geo.frame(in: .named("TableSpace"))
                    }
                    .onChange(of: geo.frame(in: .named("TableSpace"))) { newFrame in
                        targetPotion.globalFrame = newFrame
                    }
            }
        )
    }
}

struct InteractiveBallView: View {
    var ball: PotionType
    @Binding var allBalls: [PotionType]
    @Binding var targets: [TargetDataType]
    
    @State private var dragOffset: CGSize = .zero
    
    // Konversi string nama warna menjadi tipe Color SwiftUI
    private var ballColor: Color {
        switch ball.colorName {
        case "red": return .red
        case "blue": return .blue
        case "purple": return .purple
        default: return .gray
        }
    }

    var body: some View {
        // Menggunakan Circle bawaan sebagai representasi visual bola Anda
        loadBundledImage("\(ball.colorName)")
            .resizable()
            .scaledToFit()
            .frame(maxWidth: 70)
            // Ditambah 35 agar titik tengah koordinat objek berada tepat di tengah lingkaran berukuran 70x70
            .position(x: ball.position.x + 35, y: ball.position.y + 35)
            .offset(dragOffset)
            .gesture(
                DragGesture(coordinateSpace: .named("TableSpace"))
                    .onChanged { gesture in
                        dragOffset = gesture.translation
                    }
                    .onEnded { gesture in
                        if let index = allBalls.firstIndex(where: { $0.id == ball.id }) {
                            let finalPosition = CGPoint(
                                x: allBalls[index].position.x + gesture.translation.width,
                                y: allBalls[index].position.y + gesture.translation.height
                            )
                            
                            allBalls[index].position = finalPosition
                            dragOffset = .zero
                            
                            if checkTargetDrop(at: finalPosition, currentBall: allBalls[index], currentIndex: index) {
                                return
                            }
                            
                            checkBallMerge(for: allBalls[index], currentIndex: index)
                        }
                    }
            )
    }
    
    // Logika Mendeteksi apakah Bola dilepas di atas Target Potion Box
    private func checkTargetDrop(at dropPoint: CGPoint, currentBall: PotionType, currentIndex: Int) -> Bool {
        // Titik tengah bola saat di-drop
        let ballCenter = CGPoint(x: dropPoint.x + 35, y: dropPoint.y + 35)
        
        for i in targets.indices {
            // Periksa apakah titik tengah bola masuk ke dalam area persegi Target Potion Box
            if targets[i].globalFrame.contains(ballCenter) {
                // Periksa kesamaan warna antara bola dan target
                if targets[i].colorName == currentBall.colorName {
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
        
        let primaryColors: Set<String> = ["red", "blue", "yellow"]
        
        for index in allBalls.indices {
            if index == currentIndex { continue }
            
            let targetBall = allBalls[index]
            let distance = sqrt(pow(activeBall.position.x - targetBall.position.x, 2) + pow(activeBall.position.y - targetBall.position.y, 2))
            
            if distance < mergeThreshold {
                let colorA = activeBall.colorName
                let colorB = targetBall.colorName
                
                var finalColorTarget: String? = nil
                
                // ==========================================
                // LOGIKA 1: PENGURANGAN WARNA (SECONDARY - PRIMARY)
                // ==========================================
                
                // Kasus 1: Purple (Red + Blue) dikurangi salah satunya
                if (colorA == "purple" && colorB == "min_blue") || (colorA == "min_blue" && colorB == "purple") {
                    finalColorTarget = "red"
                } else if (colorA == "purple" && colorB == "min_red") || (colorA == "min_red" && colorB == "purple") {
                    finalColorTarget = "blue"
                }
                
                // Kasus 2: Orange (Red + Yellow) dikurangi salah satunya
                else if (colorA == "orange" && colorB == "min_red") || (colorA == "min_red" && colorB == "orange") {
                    finalColorTarget = "yellow"
                } else if (colorA == "orange" && colorB == "min_yellow") || (colorA == "min_yellow" && colorB == "orange") {
                    finalColorTarget = "red"
                }
                
                // Kasus 3: Green (Blue + Yellow) dikurangi salah satunya
                else if (colorA == "green" && colorB == "min_blue") || (colorA == "min_blue" && colorB == "green") {
                    finalColorTarget = "yellow"
                } else if (colorA == "green" && colorB == "min_yellow") || (colorA == "min_yellow" && colorB == "green") {
                    finalColorTarget = "blue"
                }
                
                // ==========================================
                // LOGIKA 2: PENAMBAHAN WARNA (PRIMARY + PRIMARY)
                // ==========================================
                else if (colorA == "red" && colorB == "blue") || (colorA == "blue" && colorB == "red") {
                    finalColorTarget = "purple"
                } else if (colorA == "red" && colorB == "yellow") || (colorA == "yellow" && colorB == "red") {
                    finalColorTarget = "orange"
                } else if (colorA == "blue" && colorB == "yellow") || (colorA == "yellow" && colorB == "blue") {
                    finalColorTarget = "green"
                }
                
                // ==========================================
                // LOGIKA 3: KONDISI GAGAL (COKLAT)
                // ==========================================
                else if primaryColors.contains(colorA) || primaryColors.contains(colorB) {
                    finalColorTarget = "brown"
                }
                
                // Eksekusi perubahan ke dalam array jika kombinasi valid ditemukan
                if let resultColor = finalColorTarget {
                    // Bola target berubah menjadi warna sisa hasil pengurangan/penambahan
                    allBalls[index].colorName = resultColor
                    
                    // Hapus bola aktif yang sedang di-drag karena sudah melebur ke dalam proses operasi
                    allBalls.removeAll(where: { $0.id == activeBall.id })
                    break
                }
            }
        }
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
        WorkBenchOnly(balls: $potionsList, targets: $targetList, isLayoutInitialized: $isLayoutInitialized)
    }
}

#Preview {
    WorkBenchOnly_PreviewContainer()
}
