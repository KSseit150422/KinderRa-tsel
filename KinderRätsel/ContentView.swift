//
//  ContentView.swift
//  KinderRätsel
//
//  Created by Karlheinz on 20.08.24.
//

import SwiftUI
import CoreData


struct ContentView: View {
    var body: some View {
        NavigationView {
            ZStack {
                // Bild als Hintergrund
                Image("Storch")
                    .resizable()
                    .scaledToFill()
                    .opacity(0.8)
                    .ignoresSafeArea()

                VStack {
                    Text("Naturrätsel\nfür Kinder")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .offset(x: 0, y: 200)  // Manuelle Positionierung

                    Spacer()

                    // Navigationsbutton
                    NavigationLink(destination: QuizView()) {
                        Text("Rätsel beginnen")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    .offset(x: 0, y: 280)  // Manuelle Positionierung

                    Spacer()
                }
            }
            .navigationBarHidden(true)  // Versteckt die Navigationsleiste auf der Eingangsseite
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
