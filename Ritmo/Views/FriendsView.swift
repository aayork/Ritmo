//
//  FriendsView.swift
//  Ritmo
//
//  Created by Aidan York on 2/13/24.
//

import SwiftUI
import GameKit

struct FriendsView: View {
    let localPlayer = GKLocalPlayer.local
    @State var showGameCenter = false
    
    var body: some View {
        Button("Show Leaderboard") {
            showGameCenter = true
        }
        .sheet(isPresented: $showGameCenter) {
            GameCenterView()
        }
    }
}

struct GameCenterView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> GKGameCenterViewController {
        let viewController = GKGameCenterViewController(state: .leaderboards)
        viewController.leaderboardIdentifier = "DailyHighScores" // Set your leaderboard ID here
        viewController.gameCenterDelegate = context.coordinator
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: GKGameCenterViewController, context: Context) {
        // Update the view controller if needed.
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, GKGameCenterControllerDelegate {
        var parent: GameCenterView
        
        init(_ parent: GameCenterView) {
            self.parent = parent
        }
        
        func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
            // Handle the dismissal here if needed
        }
    }
}

struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView()
    }
}



#Preview {
    FriendsView()
}
