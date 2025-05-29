//
//  DriverDetailView.swift
//  FormulaOne
//
//  Created by Michał Banaszek on 29/05/2025.
//


import SwiftUI

struct DriverDetailView: View {
    @ObservedObject var driver: Driver
    @Environment(\.managedObjectContext) private var context

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("\(driver.name ?? "") \(driver.surname ?? "")").font(.largeTitle).bold()
                if let birthDate = driver.birthDate {
                    Text("Born: \(birthDate.formatted(date: .long, time: .omitted))")
                }
                Text("Nationality: \(driver.nationality ?? "")")
                Text("Wins: \(driver.wins)")
                Text("Podiums: \(driver.podiums)")
                Text("Championships: \(driver.championships)")
                Text("Debut: \(driver.debutYear)")
                Text(driver.biography ?? "").font(.body)

                Button(action: {
                    driver.isFavourite.toggle()
                    try? context.save()
                }) {
                    HStack {
                        Image(systemName: driver.isFavourite ? "star.fill" : "star")
                        Text(driver.isFavourite ? "Remove from Favourites" : "Add to Favourites")
                    }
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
            }
            .padding()
        }
        .navigationTitle(driver.name ?? "")
    }
}