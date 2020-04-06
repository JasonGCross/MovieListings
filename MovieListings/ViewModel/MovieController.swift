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

final class DataSourceManager : ObservableObject {
    
    @Published var movies : [Movie] = []
    
    let objectWillChange = PassthroughSubject<Void, Never>()
    private var cachedMovieDetails : Dictionary<String, MovieDetail> = Dictionary<String, MovieDetail>()
    
    // do not expose the Objective-C reference types outside
    private var movieControllerWrapper : MovieControllerWrapper
    
    init(movieControllerWrapper : MovieControllerWrapper) {
        self.movieControllerWrapper = movieControllerWrapper
    }
    
    public func getMovies() -> Array<Movie> {
        guard let movieObjects = self.movieControllerWrapper.getMovies() else {
            return Array<Movie>()
        }
        
        self.movies = Movie.convertMovieWrappersToMovies(movieWrappers: movieObjects)
        return self.movies
    }
    
    public func getMovieDetails(forMovieName name:String) -> MovieDetail? {
        guard let movieDetailObject = self.movieControllerWrapper.getMovieDetails(for: name) else {
            return nil
        }
        return MovieDetail(details: movieDetailObject)
    }
    
    public func getCachedDetails(forMovieName name: String) -> MovieDetail? {
        return self.cachedMovieDetails[name]
    }
    
    public func fetchDetails(forMovieName name: String) -> Void {
        // simulate a network request to the API. Use a background thread.
        let queue = DispatchQueue(label: "data controller queue",
                                  qos: DispatchQoS.background,
                                  attributes: [],
                                  autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.inherit,
                                  target: nil)
        
        queue.asyncAfter(deadline: .now() + 3.0) {
            guard let movieDetailObject = self.getMovieDetails(forMovieName: name) else {
                return
            }
            self.cachedMovieDetails[name] = movieDetailObject

            self.objectWillChange.send()
        }
    }
}
