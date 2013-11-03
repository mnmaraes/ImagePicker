//
//  IPPhoto.h
//  ImagePicker
//
//  Created by Murillo Nicacio de Maraes on 11/2/13.
//  Copyright (c) 2013 midle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPPhoto : NSObject

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *description;

-(id)initWithPhotoURI:(NSURL *)url;
-(id)initWithPhotoURI:(NSURL *)url title:(NSString *)title andDescription:(NSString *)description;

-(UIImage *)image;

@end
