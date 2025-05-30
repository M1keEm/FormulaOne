//
//  TeamDetailView.swift
//  FormulaOne
//
//  Created by Michał Banaszek on 29/05/2025.
//

import SwiftUI
import CoreData

struct TeamDetailView: View {
    @ObservedObject var team: Team
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showQuiz = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                AsyncImage(url: URL(string: team.logoURL ?? "")) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 100)
                } placeholder: {
                    ProgressView()
                }
                .frame(maxWidth: .infinity)
                
                Text(team.name ?? "")
                    .font(.largeTitle)
                    .bold()
                
                Group {
                    DetailRow(title: "Country", value: team.country ?? "")
                    DetailRow(title: "Founded", value: "\(team.foundationYear)")
                    DetailRow(title: "Championships", value: "\(team.championships)")
                }
                
                Text("History")
                    .font(.title2)
                    .bold()
                Text(team.history ?? "")
                    .font(.body)
                
                if let driversSet = team.drivers as? Set<Driver>, !driversSet.isEmpty {
                    Text("Current Drivers")
                        .font(.title2)
                        .bold()
                    
                    ForEach(Array(driversSet), id: \.self) { driver in
                        NavigationLink(destination: DriverDetailView(driver: driver)) {
                            HStack {
                                Text("\(driver.name ?? "") \(driver.surname ?? "")")
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                        }
                        .buttonStyle(.plain)
                    }
                }
                
                if team.quiz != nil {
                    Button(action: { showQuiz = true }) {
                        Text("Take Team Quiz")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .sheet(isPresented: $showQuiz) {
                        QuizView(viewModel: QuizViewModel(), team: team)
                    }
                }
            }
            .padding()
        }
        .navigationTitle(team.name ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: toggleFavourite) {
                    Image(systemName: team.isFavourite ? "star.fill" : "star")
                        .foregroundColor(team.isFavourite ? .yellow : .gray)
                }
            }
        }
    }
    
    private func toggleFavourite() {
        team.isFavourite.toggle()
        do {
            try viewContext.save()
        } catch {
            print("Failed to save favourite status: \(error)")
        }
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .bold()
            Spacer()
            Text(value)
        }
    }
}
