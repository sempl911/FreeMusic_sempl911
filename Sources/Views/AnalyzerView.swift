//
//  AnalyzerView.swift
//  FreeMusicApp
//
//  Created by Алексей Кустов on 02.11.2024.
//

import Foundation
import SwiftUI

struct AnalyzerView : View {
    @StateObject var analyzerViewModel = AnalyzerViewModel()
    @ObservedObject var playerControlsModel: PlayerControlsModel
    @State private var isAnalyzing: Bool = false
    @State private var timer: Timer?
    
    private let maxAmplitudeHeight: CGFloat = 70 // Максимальная высота амплитуды
    
    var body: some View {
        VStack {
            HStack(spacing: 10) {
                ForEach(analyzerViewModel.amplitudes.indices, id: \.self) { index in
                    VStack {
                        Spacer()
                        Rectangle()
                            .fill(Color.blue)
                            .frame(width: 30, height: min(CGFloat(analyzerViewModel.amplitudes[index]) * maxAmplitudeHeight, maxAmplitudeHeight))
                            .cornerRadius(10)
                            .animation(.easeInOut(duration: 0.3), value: analyzerViewModel.amplitudes[index])
                    }
                }
            }
            .frame(height: maxAmplitudeHeight) // Фиксируем высоту контейнера
            .padding()
            
//            Text("Is Playing: \(playerControlsModel.isPlaying ? "Yes" : "No")")
                .padding()
        }
        .onAppear {
            // Запускаем таймер при появлении представления
            timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
                checkAnalyzingStatus()
            }
        }
        .onDisappear {
            if isAnalyzing {
                analyzerViewModel.stopAnalyzer() // Останавливаем анализ при исчезновении представления
                isAnalyzing = false // Обновляем состояние анализа
            }
            timer?.invalidate() // Очищаем таймер
        }
    }
    private func checkAnalyzingStatus() {
        if playerControlsModel.isPlaying {
            // Запускаем анализ только если он не уже запущен
            if !isAnalyzing {
                analyzerViewModel.startAnalyzer()
                isAnalyzing = true // Обновляем состояние анализа
            }
        } else {
            // Останавливаем анализ, если он запущен
            if isAnalyzing {
                analyzerViewModel.stopAnalyzer()
                isAnalyzing = false // Обновляем состояние анализа
            }
        }
    }
}
