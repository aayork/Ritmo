//
//  HomeView.swift
//  vision-app
//
//  Created by Aidan York on 2/10/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            Text("Welcome To Music Space")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .padding(25)
            
            Text("Recent Songs")
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            List {
                Text("Something in the Orange - Zach Bryan")
                
            }
            .border(Color.clear, width: 3)
            .background(Color.clear)
            .padding(10)
        }
    }
}

#Preview {
    HomeView()
}
