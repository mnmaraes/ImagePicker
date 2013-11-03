//
//  IPCameraViewController.m
//  ImagePicker
//
//  Created by Murillo Nicacio de Maraes on 10/25/13.
//  Copyright (c) 2013 midle. All rights reserved.
//

#import "IPCameraViewController.h"
#import "IPImageViewController.h"
#import "IPOverlayView.h"

@interface IPCameraViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic) UIImagePickerController* imagePicker;
@property (nonatomic) UIView* overlay;

@end

@implementation IPCameraViewController

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
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    self.imagePicker.delegate = self;
    self.imagePicker.showsCameraControls = NO;
    
    [self.imagePicker.view setFrame:self.view.bounds];
    
    
    [self configOverlay];
    
    [self addChildViewController:self.imagePicker];
    [self.view addSubview:self.imagePicker.view];
    [self.imagePicker didMoveToParentViewController:self];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toImageView"]) {
        IPImageViewController* destination = (IPImageViewController*)segue.destinationViewController;
        
        destination.image = (UIImage*)sender;
    }
}

-(void)configOverlay
{
    IPOverlayView* overlayView = [[[NSBundle mainBundle] loadNibNamed:@"IPOverlayView" owner:self options:nil] firstObject];
    [overlayView setFrame:self.view.bounds];
    
    [overlayView.photoButton addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
    [overlayView.overlayButton addTarget:self action:@selector(toggleOverlay) forControlEvents:UIControlEventTouchUpInside];
    [overlayView.cancelButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    
    self.overlay = [UIView new];
    [self.overlay setFrame:CGRectMake(overlayView.bounds.size.width/2 - 100., overlayView.bounds.size.height/2 - 100., 200., 200.)];
    [self.overlay.layer setBorderWidth:1.0];
    UIColor* color = [UIColor colorWithWhite:1.0 alpha:1.0];
    [self.overlay.layer setBorderColor:[color CGColor]];
    [self.overlay setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.0]];
    
    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveOverlay:)];
    UIPinchGestureRecognizer* pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(resizeOverlay:)];
    
    [self.overlay addGestureRecognizer:pan];
    [self.overlay addGestureRecognizer:pinch];
    
    [overlayView addSubview:self.overlay];
    
    [self.imagePicker setCameraOverlayView:overlayView];
}

#pragma mark - Button Actions
-(void)takePhoto
{
    [self.imagePicker takePicture];
}

-(void)toggleOverlay
{
    self.overlay.hidden = !self.overlay.hidden;
}

-(void)goBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (!self.overlay.hidden) {
        CGSize instagramSize = CGSizeMake(612., 612.);
        
        CGFloat scale = instagramSize.width / self.overlay.bounds.size.width;
        CGFloat imgAspectRatio = image.size.width / image.size.height;
        CGFloat correction = self.view.bounds.size.height * imgAspectRatio - self.view.bounds.size.width;
        
        CGRect rect = CGRectMake(-(self.overlay.frame.origin.x + correction/2)* scale, -self.overlay.frame.origin.y * scale, self.view.bounds.size.height * scale * imgAspectRatio, self.view.bounds.size.height * scale);
        
        UIGraphicsBeginImageContext(instagramSize);
        
        [image drawInRect:rect];
        
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
    }
    
    [self performSegueWithIdentifier:@"toImageView" sender:image];
}

#pragma mark - UIGestureRecognizerMethods

-(void)resizeOverlay:(UIPinchGestureRecognizer*)recognizer
{
    [self scaleView:self.overlay withSender:recognizer];
}

-(void)moveOverlay:(UIPanGestureRecognizer*)recognizer
{
    [self translateView:self.overlay withSender:recognizer];
}

#pragma mark - Translation

-(void)translateView:(UIView*)view withSender:(UIPanGestureRecognizer*)sender
{
    CGPoint trans = [self newTransWithRect:view.frame withTranslation:[sender translationInView:[view superview]] withinBounds:[view superview].frame];
    view.center = CGPointMake(view.center.x + trans.x, view.center.y + trans.y);
    [sender setTranslation:CGPointMake(0.0, 0.0) inView:[view superview]];
}

#pragma mark - Scaling

-(void)scaleView:(UIView*)view withSender:(UIPinchGestureRecognizer*)sender
{
    CGFloat newH = view.bounds.size.height * sender.scale;
    CGFloat newW = view.bounds.size.width * sender.scale;
    
    CGFloat maxW = [view superview].bounds.size.width;
    CGFloat maxH = [view superview].bounds.size.height;
    
    if (newW > maxW) {
        newW = newH = maxW;
    }
    
    view.bounds = CGRectMake(0.0, 0.0, newW, newH);
    
    if (view.frame.origin.x < 0.0) {
        view.center = CGPointMake(view.center.x - view.frame.origin.x, view.center.y);
    } else if (view.frame.origin.x + view.bounds.size.width > maxW) {
        CGFloat delta = maxW - (view.frame.origin.x + view.bounds.size.width);
        view.center = CGPointMake(view.center.x + delta, view.center.y);
    }
    
    if (view.frame.origin.y < 0.0) {
        view.center = CGPointMake(view.center.x, view.center.y - view.frame.origin.y);
    } else if (view.frame.origin.y + view.bounds.size.height > maxH) {
        CGFloat delta = maxH - (view.frame.origin.y + view.bounds.size.height);
        view.center = CGPointMake(view.center.x, view.center.y + delta);
    }
    
    sender.scale = 1.0;
}


//Bad Name.
-(CGPoint)newTransWithRect:(CGRect)rect withTranslation:(CGPoint)trans withinBounds:(CGRect)bounds
{
    CGPoint min = bounds.origin;
    CGPoint max = CGPointMake(bounds.origin.x + bounds.size.width - rect.size.width, bounds.origin.y + bounds.size.height - rect.size.height);
    
    return CGPointMake([self calcMinTransWithOrigin:rect.origin.x translation:trans.x minimum:min.x andMaximum:max.x],
                       [self calcMinTransWithOrigin:rect.origin.y translation:trans.y minimum:min.y andMaximum:max.y]);
    
}

-(CGFloat)calcMinTransWithOrigin:(CGFloat)origin translation:(CGFloat)trans minimum:(CGFloat)min andMaximum:(CGFloat)max
{
    return origin + trans <= min ? min - origin : (origin + trans >= max ? max - origin : trans);
}

@end
