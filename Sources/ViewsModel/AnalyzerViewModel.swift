//
//  AnalyzerViewModel.swift
//  FreeMusicApp
//
//  Created by Алексей Кустов on 02.11.2024.
//

import Foundation
import Combine

class AnalyzerViewModel: ObservableObject {
    @Published var amplitudes: [Double] = []
    private var model = AnalyzerModel()
    private var isGenerating = false
    
        func startAnalyzer() {
            
            guard !isGenerating else { return }
            isGenerating = true
            
            model.startGeneratingAmplitude { [weak self] newAmplitudes in
                DispatchQueue.main.async {
                    self?.amplitudes = newAmplitudes
                }
            }
        }
        
        func stopAnalyzer() {
            model.stopGeneratingAmplitude()
            isGenerating = false
        }
}
