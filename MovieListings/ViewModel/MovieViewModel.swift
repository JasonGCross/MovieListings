//
//  File.swift
//  Swift_to_CPP_command_line
//
//  Created by Jason Cross on 2020-04-04.
//  Copyright © 2020 Jason Cross. All rights reserved.
//

import Foundation
import Combine

/**
 Encapsulates information about a Movie
 */
final class MovieViewModel : Identifiable, ObservableObject {
    
    // required by Identifiable; allows this to be used as a List item
    var id = UUID()
    
    // required by ObservableObject; allows this to notify subscribers of a change
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    // do not expose the Objective-C reference types outside
    private var movieWrapper : MovieWrapper
    private var movieDetailWrapper : MovieDetailWrapper
    
    // instead, wrap the desired properties in value types
    var name : String {
        get {
            return movieWrapper.name
        }
    }
    
    var lastUpdated : Int {
        get {
            return Int(movieWrapper.lastUpdated)
        }
    }
    
    var score : Float {
        return self.movieDetailWrapper.score
    }
    
    var movieDescription : String {
        return self.movieDetailWrapper.movieDescription
    }
    
    var actors : Array<ActorViewModel> {
        get {
            var value = Array<ActorViewModel>()
            
            for actorWrapper in self.movieDetailWrapper.actors {
                value.append(ActorViewModel(actorWrapper: actorWrapper))
            }
            
            return value
        }
    }
    
    init(movieWrapper : MovieWrapper) {
        self.movieWrapper = movieWrapper
        
        let movieDetailWrapper = MovieDetailWrapper()
        movieDetailWrapper.name = movieWrapper.name
        movieDetailWrapper.score = 0
        movieDetailWrapper.movieDescription = String()
        movieDetailWrapper.actors = Array<ActorWrapper>()
        self.movieDetailWrapper = movieDetailWrapper
    }
    
    convenience init(name: String) {
        let movieWrapper = MovieWrapper()
        movieWrapper.name = name
        
        self.init(movieWrapper: movieWrapper)
    }
    
    
    /**
     converts an array of Movie Wrapper reference types, to an array of equivalent value types
     
     This function allows us to what the is available as incoming data (incoming from the Objective-C wrapper) and allow the data to be easily used by Swift UI via the Combine framework
     
     - Parameter movieWrappers: the array of Movie Wrapper reference types
     
     - Returns: an array of Movie value types
     */
    public static func convertMovieWrappersToMovies(movieWrappers: Array<MovieWrapper>) -> Array<MovieViewModel> {
        var value = Array<MovieViewModel>()
        
        for movieWrapper in movieWrappers {
            value.append(MovieViewModel(movieWrapper: movieWrapper))
        }
        
        return value
    }
    
    /**
     Updates the metadata for this movie.
     
     Typically it is expected that an API will return two different "views" of the data:
       1. a non-verbose view, with minimal details. This is useful for fetching a large list of objects
       2. a verbose view, with all available details. This is useful for showing the user all the information about a single object
     
     - Parameter details: the movie details (as they are returned from the API) to be merged into this movie object
     */
    public func updateUnderlyingDetails(details: MovieDetailWrapper) {
        self.movieDetailWrapper = details
        objectWillChange.send()
    }
    
}
