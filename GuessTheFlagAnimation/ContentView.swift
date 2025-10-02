//
//  ContentView.swift
//  GuessTheFlagAnimation
//
//  Created by Corey Burgos on 10/2/25.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = [
        "Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland",
        "Spain", "UK", "Ukraine", "US",
    ].shuffled()

    @State private var correctAnswer = Int.random(in: 0...2)

    @State private var showingScore = false
    @State private var showingFinalScore = false
    @State private var scoreTitle = ""
    @State private var scoreMessage = ""
    @State private var score = 0
    @State private var questionsAsked = 0

    @State private var animationAmount = [0.0, 0.0, 0.0]

    var body: some View {
        ZStack {
            RadialGradient(
                stops: [
                    .init(
                        color: Color(red: 0.1, green: 0.2, blue: 0.45),
                        location: 0.3
                    ),
                    .init(
                        color: Color(red: 0.76, green: 0.15, blue: 0.26),
                        location: 0.3
                    ),
                ],
                center: .top,
                startRadius: 200,
                endRadius: 700
            )
            .ignoresSafeArea()

            VStack {
                Spacer()

                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)

                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))

                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }

                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                            withAnimation {
                                animationAmount[number] += 360
                            }
                        } label: {
                            Image(countries[number])
                                .clipShape(.capsule)
                                .shadow(radius: 5)
                                .rotation3DEffect(
                                    .degrees(animationAmount[number]),
                                    axis: (x: 0, y: 1, z: 0)
                                )
                                .animation(
                                    .easeInOut(duration: 0.6),
                                    value: animationAmount[number]
                                )
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))

                Spacer()
                Spacer()

                Text("Score: \(score)")
                    .foregroundStyle(.white)
                    .font(.title.bold())

                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text(scoreMessage)
        }

        .alert("Game Over", isPresented: $showingFinalScore) {
            Button("Restart", action: resetGame)
        } message: {
            Text("\(finalVerdict())\nFinal score: \(score)/8")
        }
    }

    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct!"
            score += 1
            scoreMessage = "Your score is \(score)."
        } else {
            scoreTitle = "Wrong!"
            score -= 1
            scoreMessage =
                "That's the flag of \(countries[number]).\nYour score is \(score)."
        }

        questionsAsked += 1

        if questionsAsked == 8 {
            showingFinalScore = true
        } else {
            showingScore = true
        }
    }

    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }

    func resetGame() {
        score = 0
        questionsAsked = 0
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }

    func finalVerdict() -> String {
        switch score {
        case 7...8: return "Excellent!"
        case 5...6: return "Nice!"
        case 3...4: return "Not bad!"
        default: return "Keep practicing! Try again!"
        }
    }
}

#Preview {
    ContentView()
}
