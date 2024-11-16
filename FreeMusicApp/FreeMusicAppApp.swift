//
//  FreeMusicAppApp.swift
//  FreeMusicApp
//
//  Created by Алексей Кустов on 26.10.2024.
//

import SwiftUI

@main
struct FreeMusicAppApp: App {
    
    var sqlManager = SQLManager.shared

        init() {
            sqlManager.setupDatabase()
        }
    
    var body: some Scene {
        WindowGroup {
            StartView()
        }
    }
}
