//
//  CarListView.swift
//  FormulaOne
//
//  Created by Michał Banaszek on 29/05/2025.
//

import SwiftUI
import CoreData

struct CarListView: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Car.model, ascending: true)],
        animation: .default
    ) var cars: FetchedResults<Car>
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(cars) { car in
                    NavigationLink(destination: CarDetailView(car: car)) {
                        CarRowView(car: car)
                    }
                    .swipeActions(edge: .trailing) {
                        Button {
                            toggleFavorite(car: car)
                        } label: {
                            Label("Favorite", systemImage: car.isFavourite ? "star.slash" : "star")
                        }
                        .tint(car.isFavourite ? .gray : .yellow)
                    }
                }
            }
            .navigationTitle("Cars")
        }
    }
    
    private func toggleFavorite(car: Car) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        car.isFavourite.toggle()
        do {
            try viewContext.save()
        } catch {
            print("Failed to save favorite status: \(error)")
        }
    }
}

struct CarRowView: View {
    @ObservedObject var car: Car
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(car.model ?? "")
                .font(.headline)
            Text("Engine: \(car.engine ?? "")")
                .font(.subheadline)
            if car.isFavourite {
                HStack {
                    Spacer()
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                }
            }
        }
    }
}
