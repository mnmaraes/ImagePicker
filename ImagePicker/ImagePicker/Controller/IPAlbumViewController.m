//
//  IPAlbumViewController.m
//  ImagePicker
//
//  Created by Murillo Nicacio de Maraes on 11/2/13.
//  Copyright (c) 2013 midle. All rights reserved.
//

#import "IPAlbumViewController.h"

@interface IPAlbumViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *albumCollection;

@end

@implementation IPAlbumViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
