//
//  DriverListView.swift
//  FormulaOne
//
//  Created by Michał Banaszek on 29/05/2025.
//


import SwiftUI

struct DriverListView: View {
    @FetchRequest(entity: Driver.entity(), sortDescriptors: []) var drivers: FetchedResults<Driver>

    var body: some View {
        NavigationStack {
            List(drivers, id: \.self) { driver in
                NavigationLink(destination: DriverDetailView(driver: driver)) {
                    VStack(alignment: .leading) {
                        Text("\(driver.name ?? "") \(driver.surname ?? "")")
                            .font(.headline)
                        Text("Nationality: \(driver.nationality ?? "")")
                            .font(.subheadline)
                    }
                }
            }
            .navigationTitle("Drivers")
        }
    }
}