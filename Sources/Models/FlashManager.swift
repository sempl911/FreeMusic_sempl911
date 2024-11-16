//
//  FlashManager.swift
//  FreeMusicApp
//
//  Created by Алексей Кустов on 08.11.2024.
//

import Foundation
import AVFoundation
import SwiftUICore

class FlashManager: ObservableObject{
    
    @Published var isPartyEnabled: Bool = false {
            didSet {
                // Проверка состояния фонарика сразу при изменении флага Party Mode
                if !isPartyEnabled {
                    toggleFlashlight(isOn: false)
                }
            }
        }
    
    func toggleFlashlight(isOn: Bool) {
        guard let device = AVCaptureDevice.default(for: .video), device.hasTorch else {
            print("Torch is not available")
            print("Is party enabled - \(isPartyEnabled)")
            return
        }
        
        do {
            try device.lockForConfiguration()
            
            if isOn {
                try device.setTorchModeOn(level: 1.0)  // Включаем фонарик на максимальной яркости
                //print("Torch - ON")
            } else {
                device.torchMode = .off  // Выключаем фонарик
                // print("Torch - OFF")
            }
            
            device.unlockForConfiguration()
            
        } catch {
            print("Torch could not be used: \(error)")
        }
        
    }
    
}
