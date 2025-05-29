//
//  CarDetailView.swift
//  FormulaOne
//
//  Created by Michał Banaszek on 29/05/2025.
//


import SwiftUI

struct CarDetailView: View {
    @ObservedObject var car: Car
    @Environment(\.managedObjectContext) private var context

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(car.model ?? "").font(.largeTitle).bold()
                Text("Engine: \(car.engine ?? "")")
                Text("Horsepower: \(car.horsepower) HP")
                Text("Top Speed: \(car.topSpeed) km/h")
                Text("Production Years: \(car.productionYears ?? "")")

                Button(action: {
                    car.isFavourite.toggle()
                    try? context.save()
                }) {
                    HStack {
                        Image(systemName: car.isFavourite ? "star.fill" : "star")
                        Text(car.isFavourite ? "Remove from Favourites" : "Add to Favourites")
                    }
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
            }
            .padding()
        }
        .navigationTitle(car.model ?? "")
    }
}