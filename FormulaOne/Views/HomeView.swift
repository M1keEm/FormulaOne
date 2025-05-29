//
//  HomeView.swift
//  FormulaOne
//
//  Created by Michał Banaszek on 29/05/2025.
//


import SwiftUI

struct HomeView: View {
    var body: some View {
        TabView {
            TeamListView()
                .tabItem { Label("Teams", systemImage: "person.3.fill") }
            DriverListView()
                .tabItem { Label("Drivers", systemImage: "person.fill") }
            CarListView()
                .tabItem { Label("Cars", systemImage: "car.fill") }
            FavouritesView()
                .tabItem { Label("Favourites", systemImage: "star.fill") }
            QuizResultsView()
                .tabItem { Label("Results", systemImage: "checkmark.seal") }
        }
    }
}