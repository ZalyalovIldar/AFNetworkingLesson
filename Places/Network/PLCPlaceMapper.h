//
//  PLCPlaceMapper.h
//  Places
//
//  Created by azat on 28/11/15.
//  Copyright © 2015 azat. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PLCPlace;

@interface PLCPlaceMapper : NSObject

+ (PLCPlace *)placeWithDictionary:(NSDictionary *)dictionary;

@end
