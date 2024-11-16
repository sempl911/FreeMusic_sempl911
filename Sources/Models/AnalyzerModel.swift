//
//  AnalyzerModel.swift
//  FreeMusicApp
//
//  Created by Алексей Кустов on 02.11.2024.
//

import Foundation

class AnalyzerModel : ObservableObject {
    private let flashManager = FlashManager()
    private let amplitudeThreshold: Double = 0.3
    private var timer: Timer?
        
    func startGeneratingAmplitude(updateHandler: @escaping ([Double]) -> Void) {
        stopGeneratingAmplitude() // Останавливаем существующий таймер, если он есть
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            let amplitudes = self.generateRandomAmplitude()
            updateHandler(amplitudes)
            
            self.updateFlashlightBasedOnAmplitude(amplitudes)
        }
    }
    
    func stopGeneratingAmplitude() {
        timer?.invalidate()
        timer = nil
        flashManager.toggleFlashlight(isOn: false) // Torch off when pause or exit
        print("Generating amplitude was stopping")
    }
    
    private func generateRandomAmplitude() -> [Double] {
        // Генерация 5 случайных амплитуд от 0.0 до 1.0
        return (0..<5).map { _ in Double.random(in: 0...1) }
    }
    
    private func updateFlashlightBasedOnAmplitude(_ amplitudes: [Double]) {
            let middleAmplitude = amplitudes[amplitudes.count / 2]
            
            // Используем глобальный флаг isPartyEnabled из PartyStateManager
            if PartyStateManager.shared.isPartyEnabled {
                flashManager.toggleFlashlight(isOn: middleAmplitude>amplitudeThreshold)
            }
        }
}

