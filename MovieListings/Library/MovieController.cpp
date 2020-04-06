//
//  MovieController.cpp
//  MovieListings
//
//  Created by Jason Cross on 2020-04-04.
//  Copyright © 2020 Jason Cross. All rights reserved.
//

#include "MovieController.hpp"


std::vector<movies::Movie*> movies::MovieController::getMovies() {
    return _movies;
}

movies::MovieDetail* movies::MovieController::getMovieDetail(std::string name) {
    for (auto item:_details) {
        if (item.second->name == name) {
            return item.second;
        }
    }
    return nullptr;
}
