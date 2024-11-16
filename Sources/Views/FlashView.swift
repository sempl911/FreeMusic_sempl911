//
//  FlashView.swift
//  FreeMusicApp
//
//  Created by Алексей Кустов on 08.11.2024.
//

import SwiftUI

struct FlashView: View {
    @StateObject var flashManager = FlashManager()
    @State var flashCondition: Bool = PartyStateManager.shared.getPartyMode()

    var body: some View {
        Button(action: {
            PartyStateManager.shared.togglePartyMode()
            flashCondition = PartyStateManager.shared.getPartyMode()
            
            print("Flash cond \(flashCondition)")
        }) {
            Text(flashCondition ? "Turn Off" : "Party Time!")
                .padding()
                .background(flashCondition ? Color.red : Color.green)
                .foregroundColor(.white)
                .cornerRadius(8)
        }

    }
    
}


#Preview {
    FlashView()
}
