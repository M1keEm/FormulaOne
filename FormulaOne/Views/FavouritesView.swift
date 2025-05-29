//
//  FavouritesView.swift
//  FormulaOne
//
//  Created by Michał Banaszek on 29/05/2025.
//


import SwiftUI

struct FavouritesView: View {
    @FetchRequest(entity: Driver.entity(), sortDescriptors: [], predicate: NSPredicate(format: "isFavourite == YES")) var favouriteDrivers: FetchedResults<Driver>
    @FetchRequest(entity: Team.entity(), sortDescriptors: [], predicate: NSPredicate(format: "isFavourite == YES")) var favouriteTeams: FetchedResults<Team>
    @FetchRequest(entity: Car.entity(), sortDescriptors: [], predicate: NSPredicate(format: "isFavourite == YES")) var favouriteCars: FetchedResults<Car>

    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Drivers")) {
                    ForEach(favouriteDrivers, id: \.self) { driver in
                        NavigationLink(destination: DriverDetailView(driver: driver)) {
                            Text("\(driver.name ?? "") \(driver.surname ?? "")")
                        }
                    }
                }
                Section(header: Text("Teams")) {
                    ForEach(favouriteTeams, id: \.self) { team in
                        NavigationLink(destination: TeamDetailView(team: team)) {
                            Text(team.name ?? "")
                        }
                    }
                }
                Section(header: Text("Cars")) {
                    ForEach(favouriteCars, id: \.self) { car in
                        NavigationLink(destination: CarDetailView(car: car)) {
                            Text(car.model ?? "")
                        }
                    }
                }
            }
            .navigationTitle("Favourites")
        }
    }
}