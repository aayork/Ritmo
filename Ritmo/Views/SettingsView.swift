//
//  SettingsView.swift
//  Ritmo
//
//  Created by Aidan York on 2/10/24.
//

import SwiftUI

struct SettingsView: View {
    // State for slider value
    @State private var volume: Double = 50
    @State private var showPeople = false
    @State private var showTutorial = false
    
    let people = [
        Person(name: "Jax Cannon", description: "3D Design", imageName: "jax"),
        Person(name: "Elisa Fontanillas", description: "UI Design", imageName: "elisa"),
        Person(name: "Max Pelot", description: "Developer", imageName: "max"),
        Person(name: "Aynur Rauf", description: "Public Relations", imageName: "aynur"),
        Person(name: "Aidan York", description: "Developer", imageName: "aidan")
    ]
    
    
    var body: some View {
        ZStack {
            BlurredBackground()
            VStack {
                Text("SETTINGS")
                    .font(.custom("Soulcraft_Wide", size: 50.0))
                    .padding()
                    .padding(.bottom, 8)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundStyle(Color.electricLime)
                
                VStack {
                    
                    /*
                     Text("Hand Height")
                     .font(.custom("FormaDJRMicro-Medium", size: 30))
                     .frame(maxWidth: .infinity, alignment: .leading)
                     .padding(.horizontal, 30)
                     Slider(value: $volume, in: 0...100)
                     .tint(Color.electricLime)
                     .padding(.horizontal)
                     .padding(.bottom)
                     */
                    
                    HStack {
                        Button(action: {
                            self.showPeople = true
                        }) {
                            Text("CREDITS")
                                .foregroundColor(.white)
                                .font(.custom("Soulcraft_Wide", size: 30.0))
                                .frame(maxWidth: 225, minHeight: 52)
                        }
                        .offset(x: 200)
                        .padding(.horizontal)
                        .sheet(isPresented: $showPeople) {
                            PeopleView(people: people, showPeople: $showPeople)
                        }
                        
                        Spacer()
                        
                        Button {
                            self.showTutorial = true
                        } label: {
                            Text("TUTORIAL")
                                .foregroundColor(.white)
                                .font(.custom("Soulcraft_Wide", size: 30.0))
                                .frame(maxWidth: 225, minHeight: 52)
                        }
                        .sheet(isPresented: $showTutorial) {
                            TutorialView(showTutorial: $showTutorial)
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                }
                .frame(width: 1000, height: 400)
                .background(Rectangle().fill(Color(red: 0.17, green: 0.17, blue: 0.17)).opacity(0.6))
                .cornerRadius(20)
            }
        }
    }
}

struct Person {
    var name: String
    var description: String
    var imageName: String // The image should be included in your Assets
}

struct PeopleView: View {
    var people: [Person]
    @Binding var showPeople: Bool
    
    var body: some View {
        VStack {
            HStack {
                Text("Meet the Team!").font(.custom("Soulcraft", size: 35.0))
                    .foregroundStyle(Color.ritmoOrange)
                    .offset(x: 225)
                Button("Done") {
                    self.showPeople = false
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding()
            ForEach(people, id: \.name) { person in
                HStack {
                    Image(person.imageName) // Images should be in your asset catalog
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .padding(.horizontal)
                    VStack(alignment: .leading) {
                        Text(person.name).font(.custom("Soulcraft", size: 25.0))
                            .foregroundStyle(Color.electricLime)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(person.description).font(.custom("FormaDJRMicro-Medium", size: 17.0))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
        }
        .padding()
        .frame(width: 715, height: 715)
    }
}

struct TutorialView: View {
    @Binding var showTutorial: Bool
    
    var body: some View {
        VStack {
            HStack {
                Text("Welcome!").font(.custom("Soulcraft", size: 35.0))
                    .foregroundStyle(Color.ritmoOrange)
                Button("Done") {
                    self.showTutorial = false
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding()
            VStack {
                Text("To get started, please be sure you're signed in to an Apple Music account with an active subscription on your Apple Vision pro. From there, simply search for any song in the music tab to get started! Match your hands to the gestures on screen to earn points. Enjoy!")
            }
        }
        .padding()
        .frame(width: 400, height: 300)
    }
}

struct BlurredBackground: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.ritmoLightBlue, Color.ritmoOrange]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .blur(radius: 50) // Adjust the blur radius as needed
        .ignoresSafeArea() // Ensures the background extends to the edges of the display
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
