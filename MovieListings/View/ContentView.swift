//
//  ContentView.swift
//  MovieListings
//
//  Created by Jason Cross on 2020-04-04.
//  Copyright © 2020 Jason Cross. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var dataSource = DataManager.sharedManager
    
    var body: some View {
        NavigationView {
            VStack {
                List(self.dataSource.movies) { movie in
                    MovieTableViewCell(movie: movie)
                }
                Spacer().padding()
            }
        .navigationBarTitle("Movies")
        }
        .onAppear {
            self.dataSource.loadMovies()
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(DataManager.sharedManager)
    }
}




