//
//  MovieControllerWrapper.h
//  Swift_to_CPP_command_line
//
//  Created by Jason Cross on 2020-04-03.
//  Copyright © 2020 Jason Cross. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Encapsulates information about an Actor
 */
@interface ActorWrapper: NSObject

@property (nonatomic, copy) NSString * name;
@property (nonatomic, assign) int age;
@property (nonatomic, copy) NSURL * imageUrl;

@end


/**
 Encapsulates information about a Movie
 */
@interface MovieWrapper : NSObject

@property (nonatomic, copy) NSString * name;
@property (nonatomic, assign) int lastUpdated;

@end


/**
 Provides information / details about a particular Movie.
*/
@interface MovieDetailWrapper: NSObject

@property (nonatomic, copy) NSString * name;
@property (nonatomic, assign) float score;
@property (nonatomic, strong) NSArray<ActorWrapper *> * actors;
@property (nonatomic, copy) NSString * movieDescription;

@end


/**
 Movie Controller acts as a data controller (a data source) for Movie objects.
 */
@interface MovieControllerWrapper: NSObject

- (NSArray<MovieWrapper*> *) getMovies;
- (MovieDetailWrapper *) getMovieDetailsFor: (NSString*) movieName;

@end
