//
//  QuizResultsView.swift
//  FormulaOne
//
//  Created by Michał Banaszek on 29/05/2025.
//


import SwiftUI

struct QuizResultsView: View {
    @FetchRequest(entity: QuizResult.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \QuizResult.dateTaken, ascending: false)]) var results: FetchedResults<QuizResult>

    var body: some View {
        NavigationStack {
            List(results, id: \.self) { result in
                VStack(alignment: .leading) {
                    Text("Date: \(result.dateTaken?.formatted(date: .long, time: .shortened) ?? "-")")
                    Text("Score: \(result.score)/\(result.totalQuestions)").font(.subheadline)
                }
            }
            .navigationTitle("Quiz Results")
        }
    }
}