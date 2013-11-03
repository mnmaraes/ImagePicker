//
//  IPAlbum.m
//  ImagePicker
//
//  Created by Murillo Nicacio de Maraes on 11/2/13.
//  Copyright (c) 2013 midle. All rights reserved.
//

#import "IPAlbum.h"

@interface IPAlbum ()

@property (nonatomic, readwrite) NSMutableArray *photos;

@end

@implementation IPAlbum

-(id)initWithPhotos:(NSArray *)photos
{
    self = [super init];
    
    if (self) {
        _photos = [photos mutableCopy];
    }
    
    return self;
}

-(NSArray *)photos
{
    if (!_photos) {
        _photos = [NSMutableArray new];
    }
    
    return _photos;
}

@end
