//
//  IPPhoto.m
//  ImagePicker
//
//  Created by Murillo Nicacio de Maraes on 11/2/13.
//  Copyright (c) 2013 midle. All rights reserved.
//

#import "IPPhoto.h"

@interface IPPhoto ()

@property (nonatomic) NSURL *url;

@end

@implementation IPPhoto

-(id)initWithPhotoURI:(NSURL *)url
{
    self = [super init];
    
    if (self) {
        _url = url;
    }
    
    return self;
}

-(id)initWithPhotoURI:(NSURL *)url title:(NSString *)title andDescription:(NSString *)description
{
    self = [self initWithPhotoURI:url];
    
    if (self) {
        _title = title;
        _description = description;
    }
    
    return self;
}

-(UIImage *)image
{
    return [UIImage imageWithData:[NSData dataWithContentsOfURL:_url]];
}

@end
