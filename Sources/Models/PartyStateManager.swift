//
//  PartyStateManager.swift
//  FreeMusicApp
//
//  Created by Алексей Кустов on 09.11.2024.
//

import Foundation

// Класс для управления состоянием Party Mode
class PartyStateManager {
    // Это будет глобальное состояние, доступное в любом месте приложения
    static var shared = PartyStateManager()
    
    // Храним состояние как Published, чтобы все кто подписан могли обновляться
    @Published var isPartyEnabled: Bool = false {
            didSet {
                // Когда Party Mode выключается, мы выключаем фонарик.
                if !isPartyEnabled {
                    flashManager.toggleFlashlight(isOn: false) // Выключаем фонарик
                }
            }
        }
        
    private let flashManager = FlashManager()
    // Приватный инициализатор, чтобы нельзя было создать экземпляр класса снаружи
    private init() {}
    
    // Функция для переключения состояния Party Mode
    func togglePartyMode() {
        isPartyEnabled.toggle()
    }
    
    // Функция для явного задания состояния
    func setPartyMode(to state: Bool) {
        isPartyEnabled = state
    }
    
    // Получение состояния
    func getPartyMode() -> Bool {
        return isPartyEnabled
    }
}

