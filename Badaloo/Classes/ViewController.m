//
//  ViewController.m
//  CarnavalFolia
//
//  Created by Denis Nascimento on 2/12/15.
//  Copyright (c) 2015 Denis Nascimento. All rights reserved.
//

#import "ViewController.h"
#import "AAShareBubbles.h"
#import "MGInstagram.h"
#import <Social/Social.h>
#import <FacebookSDK/FacebookSDK.h>
#import <MessageUI/MessageUI.h>


#define  TAG_IMAGE 10000
#define TEXT_DEFAULT @"Foto compartilhada através do app Instanight para iPhone"

@interface ViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate,UITextViewDelegate,AAShareBubblesDelegate,UIDocumentInteractionControllerDelegate,MFMailComposeViewControllerDelegate>

@property(nonatomic,strong) UIImagePickerController  *cam;
@property(nonatomic,strong) UIDocumentInteractionController *documentInteractionController;
@property(nonatomic,strong) UIImage *currentImage;
@property(nonatomic,strong) NSString *currentFrase;
@property(nonatomic,strong) NSArray *items;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];

 [self.viewShare setFrame:CGRectMake(0, self.view.frame.size.height, self.viewShare.frame.size.width, self.viewShare.frame.size.height)];

  self.cam = [[UIImagePickerController alloc] init];
  self.cam.sourceType = UIImagePickerControllerSourceTypeCamera;
  self.cam.showsCameraControls = NO;
  self.cam.delegate = self;
  [self.cam.view setFrame:CGRectMake(0, 0, self.viewMovie.frame.size.width, self.viewMovie.frame.size.height)];
  [self.viewMovie addSubview:self.cam.view];
  [self.viewMovie addSubview:self.imageCover];
  [self.viewMovie addSubview:self.scrollView];

  self.items = [NSArray arrayWithArray:[self frases]];
  self.currentFrase = [self.items objectAtIndex:0];
  [self configScrollView];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

-(void)configShare
{
 AAShareBubbles *shareBubbles = [[AAShareBubbles alloc] initWithPoint:CGPointMake(160, 284)
                                                                radius:100
                                                                inView:self.view];
  shareBubbles.faderAlpha = 0.75f;
  shareBubbles.delegate = self;
  shareBubbles.bubbleRadius = 30; // Default is 40
  shareBubbles.showFacebookBubble = YES;
  shareBubbles.showTwitterBubble = YES;
  shareBubbles.showMailBubble = YES;
  shareBubbles.showWhatsappBubble = YES;
  shareBubbles.showInstagramBubble = YES;
  [shareBubbles show];

}

-(void)aaShareBubbles:(AAShareBubbles *)shareBubbles tappedBubbleWithType:(AAShareBubbleType)bubbleType
{
  switch (bubbleType) {
    case AAShareBubbleTypeFacebook:
      [self shareFacebook:self.currentImage];
      NSLog(@"Facebook");
      break;
    case AAShareBubbleTypeTwitter:
      [self shareTwitter:self.currentImage];
      NSLog(@"Twitter");
      break;
    case AAShareBubbleTypeMail:
      [self shareMail:self.currentImage];
      NSLog(@"Email");
      break;
    case AAShareBubbleTypeGooglePlus:
      NSLog(@"Google+");
      break;
    case AAShareBubbleTypeInstagram:
      [self shareInstagram:self.currentImage];
      NSLog(@"Tumblr");
      break;
    case AAShareBubbleTypeVk:
      NSLog(@"Vkontakte (vk.com)");
      break;
    case AAShareBubbleTypeWhatsapp:
     [ self sendWhats:self.currentImage];
      NSLog(@"Vkontakte (vk.com)");
      break;
    default:
      break;
  }
}

-(void)aaShareBubblesDidHide:(AAShareBubbles *)bubbles {
  NSLog(@"All Bubbles hidden");
}

-(void)sendWhats:(UIImage*)image
{
  if ([[UIApplication sharedApplication] canOpenURL: [NSURL URLWithString:@"whatsapp://app"]])
  {

    image = [self imageForShare:image];
    NSString * savePath  = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/whatsAppTmp.wai"];

    [UIImageJPEGRepresentation(image, 1.0) writeToFile:savePath atomically:YES];

    _documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:savePath]];
    _documentInteractionController.UTI = @"net.whatsapp.image";
    _documentInteractionController.delegate = self;

    [_documentInteractionController presentOpenInMenuFromRect:CGRectMake(0, 0, 0, 0) inView:self.view animated: YES];


  }
  else
  {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Instanight" message:@"Para compartilhar com o WhatsApps é preciso que o mesmo seja instalado." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
  }
}


-(void)shareFacebook:(UIImage*)image
{
  BOOL displayedNativeDialog = [FBNativeDialogs presentShareDialogModallyFrom:self
                                                                  initialText:TEXT_DEFAULT
                                                                        image:[self imageForShare:image]
                                                                          url:nil
                                                                      handler:nil];
  if (!displayedNativeDialog)
    [[[UIAlertView alloc]initWithTitle:@"Instanight" message:@"Configure sua conta no Facebook" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];

}

-(void)shareTwitter:(UIImage*)image
{
  if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {

    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];

    SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
      if (result == SLComposeViewControllerResultCancelled) {

        NSLog(@"Cancelled");

      } else

      {
        NSLog(@"Done");
      }

      [controller dismissViewControllerAnimated:YES completion:Nil];
    };
    controller.completionHandler =myBlock;
    [controller setInitialText:TEXT_DEFAULT];
      //  [controller addURL:[NSURL URLWithString:@"http://www.mobile.safilsunny.com"]];


    [controller addImage:[self imageForShare:image]];

    [self presentViewController:controller animated:YES completion:Nil];

  }
  else
  {
    NSLog(@"UnAvailable");
    [[[UIAlertView alloc]initWithTitle:@"Instanight" message:@"Configure sua conta do Twitter" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil]show];
  }
}


-(void)shareInstagram:(UIImage*)image
{

    // image = [self squareImageWithImage:image];
  UIImage *imagenew = [self imageForShare:image];

  if ([MGInstagram isAppInstalled] && [MGInstagram isImageCorrectSize:imagenew])
  {
    [MGInstagram postImage:imagenew withCaption:TEXT_DEFAULT  inView:self.view];
  }
  else
  {
    NSLog(@"Error Instagram is either not installed or image is incorrect size");
  }
}

-(void)shareMail:(UIImage*)image
{

  if ([MFMailComposeViewController canSendMail])
  {
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    [controller.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation_bg_iPhone.png"] forBarMetrics:UIBarMetricsDefault];
    controller.navigationBar.tintColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
    [controller setSubject:TEXT_DEFAULT];
    [controller setMessageBody:@" " isHTML:YES];
    [controller setToRecipients:[NSArray arrayWithObjects:@"",nil]];

    UIImage *image = [self squareImageWithImage:self.currentImage];

    NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation([self imageForShare:image])];
    [controller addAttachmentData:imageData mimeType:@"image/png" fileName:@" "];
    [self presentViewController:controller animated:YES completion:NULL];
  }
  else
    [[[UIAlertView alloc] initWithTitle:@"Configure uma conta de email." message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];

}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
  [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {


  self.currentImage = [info objectForKey:UIImagePickerControllerOriginalImage];
  [self.imageCover setImage:self.currentImage];

  if (picker.sourceType == UIImagePickerControllerSourceTypeSavedPhotosAlbum )
  {
    [self dismissViewControllerAnimated:YES completion:^{

      [self showViewShare];
    }];
  }
  else
    [self showViewShare];
 
}


-(void)configScrollView
{
  CGFloat x = 0.0f;

  for (int i = 0 ; i < self.items.count ; i++)
  {
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(x, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
    image.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    image.contentMode =  UIViewContentModeBottom;
    [image setBackgroundColor:[UIColor clearColor]];
    [image setImage:[UIImage imageNamed:[self.items objectAtIndex:i]]];
    image.tag = TAG_IMAGE+i;
    [self.scrollView addSubview:image];
    x += self.scrollView.frame.size.width;
  }
  [self.scrollView setContentSize:CGSizeMake(x, self.scrollView.frame.size.height)];

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
  CGFloat pageWidth = self.scrollView.frame.size.width;
  int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
  self.currentFrase = [self.items objectAtIndex:page];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //NSLog(@"image:%@",[self.items objectAtIndex:page]);
}


-(IBAction)tapCam:(id)sender
{
  [self.cam takePicture];
  [self.cam stopVideoCapture];
}
-(IBAction)tapGallery:(id)sender
{
  UIImagePickerController  *photo = [[UIImagePickerController alloc] init];
  photo.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
  photo.delegate = self;
  photo.allowsEditing = YES;
  [self presentViewController:photo animated:YES completion:nil];
}

-(IBAction)tapShare:(id)sender
{
  [self configShare];
}



-(IBAction)tapInverteCam:(id)sender
{
  if (self.cam.cameraDevice == UIImagePickerControllerCameraDeviceFront)
    [self.cam setCameraDevice:UIImagePickerControllerCameraDeviceRear];
  else
    [self.cam setCameraDevice:UIImagePickerControllerCameraDeviceFront];

}

-(IBAction)tapcancelShare:(id)sender
{
  [self hiddenViewShare];
}

- (UIImage *) mergeImages:(UIImage *)imageECG foreGround:(UIImage *)imageFlag
{
  CGSize newSize = CGSizeMake(imageECG.size.width, imageECG.size.height);
  UIGraphicsBeginImageContext( newSize );

  [imageECG drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];

  [imageFlag drawInRect:CGRectMake(0,0,newSize.width,newSize.height) blendMode:kCGBlendModeNormal alpha:1.0];

  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();

  UIGraphicsEndImageContext();
  return newImage;
}

-(void)showViewShare
{
  [UIView animateWithDuration:0.3 animations:^{
    [self.viewTakePhoto setFrame:CGRectMake(0, self.view.frame.size.height, self.viewTakePhoto.frame.size.width, self.viewTakePhoto.frame.size.height)];
  } completion:^(BOOL finished) {
    [UIView animateWithDuration:0.3 animations:^{
      [self.viewShare setFrame:CGRectMake(0, self.view.frame.size.height-self.viewShare.frame.size.height, self.viewShare.frame.size.width, self.viewShare.frame.size.height)];
    } completion:^(BOOL finished) {
      
    }];
  }];
}

-(void)hiddenViewShare
{
  [UIView animateWithDuration:0.3 animations:^{
    [self.viewShare setFrame:CGRectMake(0, self.view.frame.size.height, self.viewShare.frame.size.width, self.viewShare.frame.size.height)];
  } completion:^(BOOL finished) {
    [UIView animateWithDuration:0.3 animations:^{
      [self.viewTakePhoto setFrame:CGRectMake(0, self.view.frame.size.height-self.viewTakePhoto.frame.size.height, self.viewTakePhoto.frame.size.width, self.viewTakePhoto.frame.size.height)];
    } completion:^(BOOL finished) {
      [self.imageCover setImage:nil];
        //[self.cam startVideoCapture];
    }];
  }];
}

-(UIImage*)imageForShare:(UIImage*)image
{

  image = [self squareImageWithImage:image];

  return [self mergeImages:image foreGround:[UIImage imageNamed:self.currentFrase]];
}



-(UIImage *)squareImageWithImage:(UIImage *)image
{

  CGSize newSize = CGSizeMake(640, 640);
  double ratio;
  double delta;
  CGPoint offset;

    //make a new square size, that is the resized imaged width
  CGSize sz = CGSizeMake(newSize.width, newSize.width);

  if (image.size.width > image.size.height) {
    ratio = newSize.width / image.size.width;
    delta = (ratio*image.size.width - ratio*image.size.height);
    offset = CGPointMake(delta/2, 0);
  } else {
    ratio = newSize.width / image.size.height;
    delta = (ratio*image.size.height - ratio*image.size.width);
    offset = CGPointMake(0, delta/2);
  }

    //make the final clipping rect based on the calculated values
  CGRect clipRect = CGRectMake(-offset.x, -offset.y,
                               (ratio * image.size.width) + delta,
                               (ratio * image.size.height) + delta);


    //start a new context, with scale factor 0.0 so retina displays get
    //high quality image
  if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
    UIGraphicsBeginImageContextWithOptions(sz, YES, 0.0);
  } else {
    UIGraphicsBeginImageContext(sz);
  }
  UIRectClip(clipRect);
  [image drawInRect:clipRect];
  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();

  return newImage;
}


-(NSArray*)frases
{
  return  [NSArray arrayWithObjects:
           @"frase01.png",
           @"frase02.png",
           @"frase03.png",
           @"frase04.png",
           @"frase05.png",
           @"frase06.png",
           @"frase07.png",
           @"frase08.png",
           @"frase09.png",
           @"frase10.png",
           @"frase11.png",
           @"frase12.png",
           @"frase13.png",
           @"frase14.png",
           @"frase15.png",
           @"frase16.png",nil];
}

@end
