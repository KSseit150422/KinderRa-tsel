//
//  QuizView.swift
//  KinderRätsel
//
//  Created by Karlheinz on 22.08.24.
//

import SwiftUI

struct QuizView: View {
    @State private var currentQuestionIndex = 0
    @State private var flipped = Array(repeating: false, count: 9)
    @State private var displayedImages: [String] = Array(repeating: "", count: 9)
    @State private var questions: [Question] = []
    @State private var correctAnswerRotation: Double = 0.0
    @State private var correctIndex: Int?

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer(minLength: geometry.size.height * 0.1) // Fügt einen Abstand nach oben hinzu

                if !questions.isEmpty {
                    Button(action: {
                        self.nextQuestion()
                    }) {
                        Text(questions[currentQuestionIndex].text)
                            .font(.title)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.top, 20)
                }

                let columns = Array(repeating: GridItem(.flexible()), count: geometry.size.width > geometry.size.height ? 4 : 3)

                ScrollView { // ScrollView hinzugefügt, um im Landscape-Modus scrollen zu können
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(0..<9) { index in
                            ZStack {
                                if flipped[index] {
                                    let birdName = displayedImages[index].split(separator: "/").last!.replacingOccurrences(of: "_", with: " ")
                                    Text(birdName)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        .background(Color.gray)
                                        .cornerRadius(10)
                                } else {
                                    Image(displayedImages[index])
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        .cornerRadius(10)
                                        .rotationEffect(.degrees(index == correctIndex ? correctAnswerRotation : 0))
                                        .animation(.easeInOut(duration: 0.5), value: correctAnswerRotation)
                                }
                            }
                            .frame(width: geometry.size.width / CGFloat(columns.count) - 20, height: geometry.size.width / CGFloat(columns.count) - 20)
                            .onTapGesture {
                                if displayedImages[index] == questions[currentQuestionIndex].correctImage {
                                    withAnimation {
                                        correctAnswerRotation = 360.0 // Drehen bei richtiger Antwort
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        correctAnswerRotation = 0.0 // Zurück zur normalen Position
                                        nextQuestion()
                                    }
                                } else {
                                    withAnimation {
                                        flipped[index].toggle()
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.top, 20)

                Spacer() // Fügt einen Abstand nach unten hinzu
            }
            .padding()
            .onAppear {
                generateQuestions()
                if !questions.isEmpty {
                    setupQuestion()
                }
            }
        }
        .edgesIgnoringSafeArea(.bottom) // Verhindert, dass das Layout in den "Notch"-Bereich von iPhones gerät
    }

    private func generateQuestions() {
        guard allBirdImages.count >= 9 else {
            print("Nicht genügend Bilder für das Quiz.")
            return
        }

        for bird in allBirdImages {
            let birdName = bird.split(separator: "/").last!.replacingOccurrences(of: "_", with: " ")
            let questionText = "Wo ist die \(birdName)?"
            let question = Question(text: questionText, correctImage: bird)
            questions.append(question)
        }
        
        questions.shuffle() // Fragen in zufälliger Reihenfolge anordnen
    }

    private func setupQuestion() {
        let currentQuestion = questions[currentQuestionIndex]
        var images = allBirdImages.filter { $0 != currentQuestion.correctImage }.shuffled().prefix(8)
        images.append(currentQuestion.correctImage)
        displayedImages = images.shuffled()
        correctIndex = displayedImages.firstIndex(of: currentQuestion.correctImage)
    }

    private func nextQuestion() {
        currentQuestionIndex = (currentQuestionIndex + 1) % questions.count
        flipped = Array(repeating: false, count: 9)
        setupQuestion()
    }
}



