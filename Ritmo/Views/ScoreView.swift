//
//  ScoreView.swift
//  Ritmo
//
//  Created by Max Pelot on 3/12/24.
//

import SwiftUI

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
                        .background(Rectangle().fill(Color.green))
                }
                .buttonStyle(PlainButtonStyle())
                .cornerRadius(25)
                .zIndex(1)
                .background(
                    Rectangle()
                        .fill(Color.green)
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
                    HStack(alignment: .top) {
                        VStack {
                            VStack {
                                let songName = gameModel.musicView.selectedSong!.name
                                let artistName = gameModel.musicView.selectedSong!.artist
                                Text(songName)
                                    .font(.title3)
                                    .bold()
                                    .accessibilityHidden(true)
                                Text(artistName)
                                    .font(.subheadline)
                                    .bold()
                                    .accessibilityHidden(true)
                            }
                            .padding(20)
                            Text("Score: " + String(gameModel.score))
                                .font(.system(size: 35))
                                .bold()
                                .accessibilityLabel(Text("Score"))
                                .accessibilityValue(String(gameModel.score))
                        }
                        .padding()
                    }
                    HStack {
                        HStack {
                            ProgressView(value: progressValue, total: gameModel.musicView.selectedSong!.duration)
                                .contentShape(.accessibility, Capsule().offset(y: -3))
                                .tint(Color(uiColor: UIColor(red: 212 / 255, green: 244 / 255, blue: 4 / 255, alpha: 1.0)))
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
                           
                            if progressValue >= gameModel.musicView.selectedSong!.duration {
                                progressValue = 0
                                dismissWindow(id: "scoreView")
                                await dismissImmersiveSpace()
                                openWindow(id: "windowGroup")
                            }
                            
                            //occurs every second
                            if (gameLoopCount >= gameLoopTime) {
                                gameLoopCount = 0
                                print("Songtime: ", gameModel.songTime)
                                print("Song duration: ", gameModel.musicView.selectedSong?.duration ?? -1)
                            }
                        }
                    }
                    Task {
                        if (gameModel.isPlaying) {
                            gameModel.immsersiveView?.gameLoop(bpm: 94)
                        }
                    }
                }
            }
        }
    }
}
