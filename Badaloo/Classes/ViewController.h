//
//  ViewController.h
//  CarnavalFolia
//
//  Created by Denis Nascimento on 2/12/15.
//  Copyright (c) 2015 Denis Nascimento. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property(nonatomic,strong) IBOutlet UIView *viewMovie;
@property(nonatomic,strong) IBOutlet UIView *viewTakePhoto;
@property(nonatomic,strong) IBOutlet UIView *viewShare;
@property(nonatomic,strong) IBOutlet UIScrollView *scrollView;
@property(nonatomic,strong) IBOutlet UIButton *btntTap;
@property(nonatomic,strong) IBOutlet UIButton *btnGallery;
@property(nonatomic,strong) IBOutlet UIButton *btnInverteCam;
@property(nonatomic,strong) IBOutlet UIButton *btnShare;
@property(nonatomic,strong) IBOutlet UIImageView *imageCover;

-(IBAction)tapCam:(id)sender;
-(IBAction)tapGallery:(id)sender;
-(IBAction)tapShare:(id)sender;
-(IBAction)tapInverteCam:(id)sender;
-(IBAction)tapcancelShare:(id)sender;

@end

