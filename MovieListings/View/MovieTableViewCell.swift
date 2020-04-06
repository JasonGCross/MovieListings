//
//  MovieTableViewCell.swift
//  MovieListings
//
//  Created by Jason Cross on 2020-04-05.
//  Copyright © 2020 Jason Cross. All rights reserved.
//

import SwiftUI

struct MovieTableViewCell: View {
    let movie : MovieViewModel
    
    var body: some View {
        // use the name of the movie to go and fetch the rest of the details
        let movieDetails = DataManager.sharedManager.getMovieDetails(forMovieName: movie.name)
        
        return NavigationLink(destination: MovieDetailView(movie: movieDetails)) {
            
            Image(systemName: "film")
            Text("\(movie.name)")
        }
    }
}

struct MovieTableViewCell_Previews: PreviewProvider {
    static var previews: some View {
        let movieWrapper = MovieWrapper();
        movieWrapper.name = "Shaft"
        let data = MovieViewModel(movieWrapper: movieWrapper)
        return MovieTableViewCell(movie: data)
    }
}
