//
//  PLCLocationHelper.m
//  Places
//
//  Created by azat on 28/11/15.
//  Copyright © 2015 azat. All rights reserved.
//

#import "PLCLocationHelper.h"

NSString *stringFromCoordinate(CLLocationCoordinate2D location) {
    return [NSString stringWithFormat:@"%f,%f", location.latitude, location.longitude];
}
