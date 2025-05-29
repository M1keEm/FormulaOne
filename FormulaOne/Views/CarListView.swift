//
//  CarListView.swift
//  FormulaOne
//
//  Created by Michał Banaszek on 29/05/2025.
//


import SwiftUI

struct CarListView: View {
    @FetchRequest(entity: Car.entity(), sortDescriptors: []) var cars: FetchedResults<Car>

    var body: some View {
        NavigationStack {
            List(cars, id: \.self) { car in
                NavigationLink(destination: CarDetailView(car: car)) {
                    VStack(alignment: .leading) {
                        Text(car.model ?? "").font(.headline)
                        Text("Engine: \(car.engine ?? "")").font(.subheadline)
                    }
                }
            }
            .navigationTitle("Cars")
        }
    }
}