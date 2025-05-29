//
//  TeamDetailView.swift
//  FormulaOne
//
//  Created by Michał Banaszek on 29/05/2025.
//


import SwiftUI

struct TeamDetailView: View {
    @ObservedObject var team: Team
    @Environment(\.managedObjectContext) private var context

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(team.name ?? "")
                .font(.largeTitle).bold()
            Text("Founded: \(team.foundationYear)")
            Text("Country: \(team.country ?? "")")
            Text("Championships: \(team.championships)")
            Text(team.history ?? "")
                .font(.body)

            Button(action: {
                team.isFavourite.toggle()
                try? context.save()
            }) {
                HStack {
                    Image(systemName: team.isFavourite ? "star.fill" : "star")
                    Text(team.isFavourite ? "Remove from Favourites" : "Add to Favourites")
                }
            }
            .padding()
            .background(Color.blue.opacity(0.1))
            .cornerRadius(8)

            Spacer()
        }
        .padding()
        .navigationTitle(team.name ?? "")
    }
}