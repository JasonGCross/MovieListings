//
//  MovieDetailView.swift
//  MovieListings
//
//  Created by Jason Cross on 2020-04-04.
//  Copyright © 2020 Jason Cross. All rights reserved.
//

import SwiftUI
import Combine

struct MovieDetailView: View {
    @ObservedObject var movie : MovieViewModel
    
    var body: some View {
        VStack (alignment: .leading, spacing: 0.0) {
            VStack (alignment: .leading, spacing: 20.0) {
                ScoreView(movie: self.movie)
                VStack (alignment: .leading) {
                    Text("Synopsis")
                        .font(.caption).foregroundColor(.secondary)
                    Text(movie.movieDescription)
                        .font(.body)
                    .navigationBarTitle(Text(movie.name), displayMode: .inline)
                }
            }
            .padding(EdgeInsets(top: 0.0, leading: 20.0, bottom: 10.0, trailing: 20.0))
            Text("Cast")
                .font(.caption).foregroundColor(.secondary)
            .padding(EdgeInsets(top: 20.0, leading: 20.0, bottom: 0.0, trailing: 20.0))
            List (movie.actors) { actor in
                ActorTableViewCell(actor: actor)
            }
            Spacer().padding()
        }
        .padding(EdgeInsets(top: 30.0, leading: 0.0, bottom: 10.0, trailing: 10.0))
    }
}

struct MovieDetail_Previews: PreviewProvider {
    static var previews: some View {
        
        let movieWrapper = MovieWrapper()
        movieWrapper.name = "Return of the Jedi"
        
        let movieDetailWrapper = MovieDetailWrapper()
        movieDetailWrapper.name = movieWrapper.name
        movieDetailWrapper.score = 3.0
        movieDetailWrapper.movieDescription = "After a daring mission to rescue Han Solo from Jabba the Hutt, the Rebels dispatch to Endor to destroy the second Death Star. Meanwhile, Luke struggles to help Darth Vader back from the dark side without falling into the Emperor's trap."
        
        let actor1 = ActorWrapper()
        actor1.name = "Mark Hammill"
        actor1.age = 69
        movieDetailWrapper.actors = [actor1]
        
        let data : MovieViewModel = MovieViewModel(movieWrapper: movieWrapper)
        data.updateUnderlyingDetails(details: movieDetailWrapper)
         
        return NavigationView {
            MovieDetailView(movie: data)
        }
    }
}

struct ScoreView: View {
    @ObservedObject var movie : MovieViewModel
    
    var body: some View {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumIntegerDigits = 1
        numberFormatter.minimumFractionDigits = 1
        numberFormatter.maximumFractionDigits = 1
        numberFormatter.locale = NSLocale.current
        let scoreString : String = numberFormatter.string(from: NSNumber(value: movie.score)) ?? "0"
        
        return VStack (alignment: .leading) {
            Text("Score").font(.caption).foregroundColor(.secondary)
            Text("\(scoreString)").font(.largeTitle)
        }
    }
}
