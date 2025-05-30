//
//  DriverListView.swift
//  FormulaOne
//
//  Created by Michał Banaszek on 29/05/2025.
//

import CoreData
import SwiftUI

struct DriverListView: View {
    @FetchRequest(
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Driver.surname, ascending: true)
        ],
        animation: .default
    ) var drivers: FetchedResults<Driver>

    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        NavigationStack {
            List {
                ForEach(drivers) { driver in
                    NavigationLink(
                        destination: DriverDetailView(driver: driver)
                    ) {
                        DriverRowView(driver: driver)
                    }
                    .swipeActions(edge: .trailing) {
                        Button {
                            toggleFavorite(driver: driver)
                        } label: {
                            Label(
                                "Favorite",
                                systemImage: driver.isFavourite
                                    ? "star.slash" : "star"
                            )
                        }
                        .tint(driver.isFavourite ? .gray : .yellow)
                    }
                }
            }
            .navigationTitle("Drivers")
        }
    }

    private func toggleFavorite(driver: Driver) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        driver.isFavourite.toggle()
        do {
            try viewContext.save()
        } catch {
            print("Failed to save favorite status: \(error)")
        }
    }
}

struct DriverRowView: View {
    @ObservedObject var driver: Driver

    var body: some View {
        HStack {
            Text("\(driver.name ?? "") \(driver.surname ?? "")")
                .font(.headline)
            Spacer()
            if driver.isFavourite {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
            }
        }
    }
}
