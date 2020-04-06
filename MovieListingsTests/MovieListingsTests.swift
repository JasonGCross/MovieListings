//
//  MovieListingsTests.swift
//  MovieListingsTests
//
//  Created by Jason Cross on 2020-04-04.
//  Copyright © 2020 Jason Cross. All rights reserved.
//

import XCTest
@testable import MovieListings

class MovieListingsTests: XCTestCase {

    func testGettingMoviesFromBridge() throws {
        // access the objective-c wrappers for our data

        let dataController : MovieControllerWrapper = MovieControllerWrapper()

        guard let moviesWrappers = dataController.getMovies() else {
            XCTFail()
            return
        }
            
        let movies = MovieViewModel.convertMovieWrappersToMovies(movieWrappers: moviesWrappers)
        
        for movie in movies {
            let movieDetails = dataController.getMovieDetails(for: movie.name)
            print("The movie name: \(String(describing: movie.name))")
            print("The movie details: \(String(describing: movieDetails))")
        }
        
    }
    
    func testGettingMoviesFromSwift() throws {
        let exp = expectation(description: "wait for Swift to return data")
        let dataController = DataManager.sharedManager
        dataController.loadMovies()
        
        let queue = DispatchQueue(label: "data controller queue",
        qos: DispatchQoS.background,
        attributes: [],
        autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.inherit,
        target: nil)
        
        // wait a few seconds for the data to be fetched
        queue.asyncAfter(deadline: .now() + 3.0) {
            let movies = dataController.movies

            for movie in movies {
                let movieDetails = dataController.getMovieDetails(forMovieName: movie.name)
                
                guard movieDetails.name != String(),
                    movieDetails.movieDescription != String() else {
                    XCTFail()
                    return
                }
            }
            exp.fulfill()
        }

        
        
        waitForExpectations(timeout: 10) { (err) in
            if let error = err {
                XCTFail("failed with error: \(error)")
            }
            
            print ("waiting finished")
        }
    }
    
    func testGettingMoviesOnBackgroundThread() throws {
        let exp = expectation(description: "wait for C++ to return data")
        
        let queue = DispatchQueue(label: "data controller queue",
                                  qos: DispatchQoS.background,
                                  attributes: [],
                                  autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.inherit,
                                  target: nil)
        
        queue.asyncAfter(deadline: .now() + 3.0) {
            
            let dataController : MovieControllerWrapper = MovieControllerWrapper()

            guard let moviesWrappers = dataController.getMovies() else {
                XCTFail()
                        return
            }
                
            let movies = MovieViewModel.convertMovieWrappersToMovies(movieWrappers: moviesWrappers)
            
            for movie in movies {
                guard let movieDetails = dataController.getMovieDetails(for: movie.name),
                    movieDetails.name != String(),
                    movieDetails.movieDescription != String() else {
                    XCTFail()
                    return
                }
            }
            exp.fulfill()
        }
        

        
        waitForExpectations(timeout: 10) { (err) in
            if let error = err {
                XCTFail("failed with error: \(error)")
            }
            
            print ("waiting finished")
        }
    }


}
