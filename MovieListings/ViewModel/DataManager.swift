//
//  MovieController.swift
//  Swift_to_CPP_command_line
//
//  Created by Jason Cross on 2020-04-04.
//  Copyright © 2020 Jason Cross. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

final class DataManager : ObservableObject {
    
    public static let sharedManager = DataManager()
    @Published var movies : [MovieViewModel] = []
    
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    // do not expose the Objective-C reference types outside
    fileprivate var movieControllerWrapper : MovieControllerWrapper
    
    fileprivate init() {
        self.movieControllerWrapper = MovieControllerWrapper()
    }
    
    fileprivate func getMovies() -> Array<MovieViewModel> {
        guard let movieObjects = self.movieControllerWrapper.getMovies() else {
            return Array<MovieViewModel>()
        }
        
        self.movies = MovieViewModel.convertMovieWrappersToMovies(movieWrappers: movieObjects)
        return self.movies
    }
    
    /**
     A getter for the detailed metadata for the movie passed in.
     
     If not all metadata is immediately available, attemps to fetch missing details from the API.
     
     - Parameter name: the name of the movie to find out more metadata
     
     - Returns: a Movie View Model object with as much metadtata is available at the time of calling.
     */
    public func getMovieDetails(forMovieName name:String) -> MovieViewModel {
        var movieDetailObject = self.movies.filter({ (movie : MovieViewModel) -> Bool in
            name == movie.name
        }).first
        
        if (nil == movieDetailObject) {
            movieDetailObject = MovieViewModel(name: name)
        }
            
        // if the description exists, then the details have already been fetched
        if movieDetailObject!.movieDescription == String() {
            
            // Problem: we have not yet downloaded the details for this movie from the API.
            // Solution: go get the rest of the missing data.
            
            // this will update the reference object on a background thread
            self.fetchDetails(intoMovie: movieDetailObject!)
        }
        
        return movieDetailObject!
    }
    
    /**
     Retrieves the metadata for the movie passed in (if it is not already available).
     
     Typically it is expected that an API will return two different "views" of the data:
       1. a non-verbose view, with minimal details. This is useful for fetching a large list of objects
       2. a verbose view, with all available details. This is useful for showing the user all the information about a single object
     
     Notifies any subscribers when the details are available.
     
     - Parameter movie: the movie for which the details will be retrieved
     */
    fileprivate func fetchDetails(intoMovie movie: MovieViewModel) -> Void {
        
        // simulate a network request to the API. Use a background thread.
        let queue = DispatchQueue(label: "data controller movie detail queue",
                                  qos: DispatchQoS.background,
                                  attributes: [],
                                  autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.inherit,
                                  target: nil)
        
        queue.async {
            guard let movieDetailWrapper = self.movieControllerWrapper.getMovieDetails(for: movie.name) else {
                return
            }
            
            DispatchQueue.main.async {
                movie.updateUnderlyingDetails(details: movieDetailWrapper)
                self.objectWillChange.send()
            }
        }
    }
    
    /**
     Fetches movies from the API and stores them in memory once fetched.
     
     Notifies any subscribers once the movies have been retrieved.
     */
    public func loadMovies() {
        // simulate a network request to the API. Use a background thread.
        let queue = DispatchQueue(label: "data controller movie queue",
                                  qos: DispatchQoS.background,
                                  attributes: [],
                                  autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.inherit,
                                  target: nil)
        
        queue.async {
            guard let movieObjects = self.movieControllerWrapper.getMovies() else {
                return
            }
            
            DispatchQueue.main.async {
                self.movies = MovieViewModel.convertMovieWrappersToMovies(movieWrappers: movieObjects)
                self.objectWillChange.send()
            }
        }
    }
}
