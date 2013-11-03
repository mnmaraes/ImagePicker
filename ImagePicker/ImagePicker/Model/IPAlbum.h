//
//  IPAlbum.h
//  ImagePicker
//
//  Created by Murillo Nicacio de Maraes on 11/2/13.
//  Copyright (c) 2013 midle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPAlbum : NSObject

-(id)initWithPhotos:(NSArray *)photos;
-(NSArray *)photos;

@end
