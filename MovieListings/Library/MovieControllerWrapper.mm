//
//  MovieControllerWrapper.m
//  Swift_to_CPP_command_line
//
//  Created by Jason Cross on 2020-04-03.
//  Copyright © 2020 Jason Cross. All rights reserved.
//

#import "MovieControllerWrapper.h"
#include "MovieController.hpp"

@protocol Indentifiable;

//Mark: - Actor
@implementation ActorWrapper 

@synthesize name;
@synthesize age;

@end


//Mark: - Movie
@implementation MovieWrapper

@synthesize name;
@synthesize lastUpdated;

@end


//Mark: - Movie Detail
@implementation MovieDetailWrapper

@synthesize name;
@synthesize score;
@synthesize actors;
@synthesize movieDescription;

@end

//Mark: - Movie Controller
@implementation MovieControllerWrapper

movies::MovieController _movieController;

- (id) init {
    self = [super init];
    if (nil != self) {
        _movieController = movies::MovieController();
    }
    return self;
}

- (NSArray<MovieWrapper*> *) getMovies; {
    std::vector<movies::Movie*> movies;
    movies = _movieController.getMovies();
    NSMutableArray<MovieWrapper*>* value = [[NSMutableArray alloc] init];
    
    // convert each movie to an objective-C object
    for(movies::Movie* movie : movies) {
        MovieWrapper* movieWrapper = [[MovieWrapper alloc] init];
        movieWrapper.name = [NSString stringWithCString:movie->name.c_str()
                                               encoding:[NSString defaultCStringEncoding]];
        movieWrapper.lastUpdated = movie->lastUpdated;
        [value addObject:movieWrapper];
    }
    return [NSArray arrayWithArray:value];
}

- (MovieDetailWrapper *) getMovieDetailsFor: (NSString*) movieName; {
    if (nil == movieName) {
        return nil;
    }
    
    std::string c_string = [movieName cStringUsingEncoding:[NSString defaultCStringEncoding]];
    movies::MovieDetail * movieDetail = _movieController.getMovieDetail(c_string);
    if (nullptr == movieDetail) {
        return nil;
    }
    
    MovieDetailWrapper * value = [[MovieDetailWrapper alloc] init];
    value.name = [NSString stringWithCString:movieDetail->name.c_str()
                                    encoding:[NSString defaultCStringEncoding]];
    value.score = movieDetail->score;
    value.movieDescription = [NSString stringWithCString:movieDetail->description.c_str()
                                                encoding:[NSString defaultCStringEncoding]];
    
    // convert each actor to an Objective-C object
    NSMutableArray<ActorWrapper*> * mutableArrayOfActors = [[NSMutableArray alloc] init];
    std::vector<movies::Actor> actors = movieDetail->actors;
    for (movies::Actor actor : actors) {
        ActorWrapper * actorWrapper = [[ActorWrapper alloc] init];
        actorWrapper.name = [NSString stringWithCString:actor.name.c_str()
                                               encoding:[NSString defaultCStringEncoding]];
        actorWrapper.age = actor.age;
        NSString * urlString = [NSString stringWithCString:actor.imageUrl.c_str()
                                                  encoding:[NSString defaultCStringEncoding]];
        if (nil != urlString) {
            actorWrapper.imageUrl = [NSURL URLWithString:urlString];
        }
        [mutableArrayOfActors addObject:actorWrapper];
    }
    value.actors = [NSArray arrayWithArray:mutableArrayOfActors];
    
    return value;
}

@end
