//
//  File.swift
//  Swift_to_CPP_command_line
//
//  Created by Jason Cross on 2020-04-04.
//  Copyright © 2020 Jason Cross. All rights reserved.
//

import Foundation

/**
 Encapsulates information about a Movie
 */
final class MovieViewModel : Identifiable {
    var id = UUID()
    
    // do not expose the Objective-C reference types outside
    private var movieWrapper : MovieWrapper
    
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
    
    init(movieWrapper : MovieWrapper) {
        self.movieWrapper = movieWrapper
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
    
}
