//
//  ScoreView.swift
//  Ritmo
//
//  Created by Max Pelot on 3/12/24.
//

import SwiftUI
import MusicKit

struct ScoreView: View {
    @Environment(GameModel.self) var gameModel
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    @Environment(\.dismissWindow) private var dismissWindow
    @State private var progressValue: Double = 0
    @State private var isButtonClicked = false
    @State private var gameLoopCount = 0;
    @State var timer = Timer.publish(every: 0.001, on: .main, in: .common).autoconnect()
    private var gameLoopTime = 1_000; // 1 second in millis
    @Environment(\.scenePhase) private var scenePhase
    var body: some View {
        ZStack() {
            // Button stuff
            if !isButtonClicked { // This condition will hide the button after it's clicked
                Button(action: {
                    Task {
                        await gameModel.musicView.togglePlaying() // Wait until togglePlaying has finished
                        gameModel.isPlaying = true;
                        isButtonClicked = true // Hide the button after it's clicked
                    }
                }) {
                    Text("Play")
                        .font(.custom("Soulcraft_Wide", size: 20.0))
                        .padding()
                        .background(Rectangle().fill(Color.blue))
                }
                .buttonStyle(PlainButtonStyle())
                .cornerRadius(25)
                .zIndex(1)
                .background(
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: 460, height: 230) // Adjust the frame size as needed
                        .blur(radius: 100) // Adjust the blur radius to control the spread of the glow
                        .shadow(radius: 4)
                )
                // Additional padding to ensure the blur doesn't clip
                .padding(10)
            }
            // Button stuff
            
            HStack(alignment: .top) {
                VStack(spacing: 0) {
                    HStack() {
                        ArtworkImage(gameModel.selectedSong!.artwork, width: 125)
                            .cornerRadius(7.5)
                            .frame(alignment: .leading)
                        VStack {
                            VStack {
                                let songName = gameModel.selectedSong?.name ?? ""
                                let artistName = gameModel.selectedSong?.artist ?? ""
                                Text(songName)
                                    .font(.custom("FormaDJRMicro-Bold", size: 30.0))
                                    .foregroundStyle(Color("ritmoWhite"))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text(artistName)
                                    .font(.custom("FormaDJRMicro-Medium", size: 17.0))
                                    .foregroundStyle(Color("ritmoWhite"))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            Text("Score: " + String(gameModel.score))
                                .font(.custom("Soulcraft_Slanted-wide", size: 30.0))
                                .foregroundStyle(Color("electricLime"))
                                .accessibilityLabel(Text("Score"))
                                .accessibilityValue(String(gameModel.score))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .offset(y: 7)
                        }
                        .padding(10)
                        .padding(.horizontal, 10)
                    }
                    .padding(20)
                    .offset(x: 10, y: 5)
                    HStack {
                        HStack {
                            ProgressView(value: progressValue, total: gameModel.selectedSong?.duration ?? -1)
                                .contentShape(.accessibility, Capsule().offset(y: -3))
                                .tint(Color(.electricLime))
                                .padding(.vertical, 30)
                                .frame(width: 300)
                        }
                        .frame(width: 460)
                    }
                    .background(
                        .regularMaterial,
                        in: .rect(
                            topLeadingRadius: 0,
                            bottomLeadingRadius: 12,
                            bottomTrailingRadius: 12,
                            topTrailingRadius: 0,
                            style: .continuous
                        )
                    )
                    .frame(width: 460, height: 70)
                }
                .padding(.vertical, 12)
                .onChange(of: scenePhase) {
                    if scenePhase == .inactive {
                        Task {
                            dismissWindow(id: "scoreView")
                            openWindow(id: "windowGroup")
                            await dismissImmersiveSpace()
                            if (gameModel.musicView.playing == true) {
                                await gameModel.musicView.togglePlaying()
                            }
                            gameModel.isPlaying = false
                        }
                        gameModel.reset()
                    }
                }
                .onReceive(timer) { input in
                    Task {
                        if (gameModel.isPlaying) {
                            gameLoopCount += 1
                            gameModel.songTime += 1
                            progressValue += 1
                            
                            if progressValue >= gameModel.selectedSong?.duration ?? -1 {
                                progressValue = 0
                                dismissWindow(id: "scoreView")
                                await dismissImmersiveSpace()
                                openWindow(id: "windowGroup")
                            }
                            
                            //occurs every second
                            if (gameLoopCount >= gameLoopTime) {
                                gameLoopCount = 0
                            }
                        }
                    }
                    Task {
                        if (gameModel.isPlaying) {
                            
                            var bpm: Int
                            
                            if let genres = gameModel.selectedSong?.genres {
                                // Use a switch statement to check for specific genres
                                let genre = genres.first(where: { $0 == "Rock" || $0 == "Pop" || $0 == "Country" || $0 == "Electronic" || $0 == "Hip-Hop" || $0 == "Jazz" || $0 == "Classical" }) // Add more genres as needed
                                
                                switch genre {
                                case "Rock":
                                    bpm = 105
                                case "Pop":
                                    bpm = 100
                                case "Country":
                                    bpm = 85
                                case "Electronic":
                                    bpm = 105
                                case "Hip-Hop":
                                    bpm = 95
                                case "Jazz":
                                    bpm = 90 // Jazz can vary widely but 120 is a middle ground
                                case "Classical":
                                    bpm = 60  // Averages for Classical can vary widely; 60 bpm for slower compositions
                                default:
                                    bpm = 90
                                }
                                
                                gameModel.immsersiveView?.gameLoop(bpm: bpm)
                            }
                        }
                    }
                }
            }
        }
    }
}
