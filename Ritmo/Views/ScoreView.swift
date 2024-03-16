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
    @Environment(\.dismiss) private var dismiss
    @State private var progressValue: Double = 0
    var body: some View {
        ZStack() {
            HStack(alignment: .top) {
                VStack(spacing: 0) {
                    HStack(alignment: .top) {
                        Button {
                            Task {
                                openWindow(id: "windowGroup")
                                await dismissImmersiveSpace()
                                dismiss()
                            }
                            gameModel.reset()
                        } label: {
                            Label("Exit", systemImage: "x.circle")
                                .labelStyle(.iconOnly)
                        }
                        VStack {
                            VStack {
                                let songName = gameModel.musicView.selectedSong!.name
                                let artistName = gameModel.musicView.selectedSong!.artist
                                Text(songName)
                                    .font(.title3)
                                    .bold()
                                    .accessibilityHidden(true)
                                    .offset(y: -5)
                                Text(artistName)
                                    .font(.subheadline)
                                    .bold()
                                    .accessibilityHidden(true)
                                    .offset(y: -5)
                            }
                            .padding(20)
                            Text("Score: " + String(gameModel.score))
                                .font(.system(size: 35))
                                .bold()
                                .accessibilityLabel(Text("Score"))
                                .accessibilityValue(String(gameModel.score))
                                .offset(x: 5)
                        }
                        .padding(.leading, 10)
                        .padding(.trailing, 50)
                    }
                    HStack {
                        HStack {
                            ProgressView(value: progressValue, total: gameModel.musicView.selectedSong!.duration)
                                .contentShape(.accessibility, Capsule().offset(y: -3))
                                .tint(Color(uiColor: UIColor(red: 212 / 255, green: 244 / 255, blue: 4 / 255, alpha: 1.0)))
                                .padding(.vertical, 30)
                                .frame(width: 300)
                            Button(action: {
                                Task {
                                }
                            }) {
                                Image(systemName: gameModel.musicView.playing ? "pause.fill" : "play.fill")
                                    .padding()
                                    .background(Circle().fill(Color.green))
                            }
                            .buttonStyle(PlainButtonStyle())
                            .cornerRadius(360)
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
                    .offset(y: 15)
                }
                .padding(.vertical, 12)
                .onAppear { // Step 2: Start timer on appear
                    Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                        if progressValue < gameModel.musicView.selectedSong!.duration {
                            progressValue += 1
                        } else {
                            timer.invalidate() // Stop the timer if the duration is reached
                        }
                    }
                }
            }
        }
    }
}
