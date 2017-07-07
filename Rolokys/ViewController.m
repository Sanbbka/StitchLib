//
//  ViewController.m
//  Diplom
//
//  Created by Alexander Drovnyashin on 27.11.16.
//  Copyright © 2016 Alx. All rights reserved.
//

#import "ViewController.h"

#import "PhotoModel.h"
#import "UIColor+HexColor.h"
#import <MBProgressHUD.h>
#import "IOManager.h"

@interface ViewController ()<CTAssetsPickerControllerDelegate, UIScrollViewDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UICollectionView *collection;

@property (nonatomic, strong) NSMutableArray *arrPhotos;

@property UIImageView *imageView;

@property UIImage *imageStitch;

@end

@implementation ViewController

static NSString *identCollectCell = @"EventAddDocCollCell";

#pragma mark - lyfecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collection registerNib:[UINib nibWithNibName:identCollectCell bundle:nil] forCellWithReuseIdentifier:identCollectCell];
    
    PhotoModel *first = [PhotoModel new];
    PhotoModel *second = [PhotoModel new];
    PhotoModel *third = [PhotoModel new];
    PhotoModel *fourth = [PhotoModel new];
    
    first.mPhoto    = [UIImage imageNamed:@"pano_1"];
    second.mPhoto   = [UIImage imageNamed:@"pano_2"];
    third.mPhoto    = [UIImage imageNamed:@"pano_3"];
    fourth.mPhoto   = [UIImage imageNamed:@"pano_4"];
    
    self.arrPhotos = [NSMutableArray arrayWithObjects:first, second, third, fourth, nil];
    
    UIBarButtonItem *item = [self addNavBarButtonLeft:NO title:@"Сохранить" action:@selector(saveImage)];
    
    item.tintColor = [UIColor whiteColor];
}

- (void)saveImage {
    UIImageWriteToSavedPhotosAlbum(self.imageStitch, nil, nil, nil);
}

#pragma mark -
- (void)setArrPhotos:(NSMutableArray *)arrPhotos {
    
    _arrPhotos = arrPhotos;
    
    bool containsAddBtn = NO;
    for (PhotoModel *photo in _arrPhotos) {
        if (photo.isButton) {
            containsAddBtn = YES;
            break;
        }
    }
    
    if (!containsAddBtn)
        [self arrDocument_AddButton];
    
    [self.collection reloadData];
}


#pragma mark - tools

- (void)arrDocument_AddButton
{
    PhotoModel *photo = [PhotoModel new];
    photo.isButton = YES;
    [self.arrPhotos addObject:photo];
}


#pragma mark - Photo

- (void)photoChoose
{
    CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
    if (self.assetsLibrary != nil)
        picker.assetsLibrary = self.assetsLibrary;
    else
        self.assetsLibrary = picker.assetsLibrary;
    picker.title = @"Фото";
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.delegate = self;
    
    picker.childNavigationController.navigationBar.tintColor = [UIColor blackColor];
    picker.childNavigationController.navigationBar.barTintColor = [UIColor whiteColor];
    picker.childNavigationController.navigationBar.titleTextAttributes = @{ NSForegroundColorAttributeName : [UIColor blackColor] };
    
    NSMutableArray *arr = [NSMutableArray new];
    for (PhotoModel *calFile in self.arrPhotos) {
        if (calFile.mAsset)
            [arr addObject:calFile.mAsset];
    }
    picker.selectedAssets = arr;
    
    [self.navigationController presentViewController:picker animated:YES completion:nil];
}

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets;
{
    //удаляю всё кроме документов из события (режим редактирования)
    NSMutableIndexSet *itemsToDelete = [NSMutableIndexSet indexSet];
    for (NSInteger i = 0; i < self.arrPhotos.count; ++i)
    {
        PhotoModel *photo = self.arrPhotos[i];
        if (photo.mAsset || photo.isButton)
            [itemsToDelete addIndex:i];
    }
    [self.arrPhotos removeObjectsAtIndexes:itemsToDelete];
    
    
    for (ALAsset *asset in assets)
    {
        PhotoModel *photo = [PhotoModel new];
        photo.mAsset   = asset;
        
        if (asset == nil) continue;
        
        ALAssetRepresentation* representation = [asset defaultRepresentation];
        
        // Retrieve the image orientation from the ALAsset
        UIImageOrientation orientation = UIImageOrientationUp;
        NSNumber *orientationVal;
        orientationVal = [asset valueForProperty:@"ALAssetPropertyOrientation"];
        if (orientationVal != nil) {
            orientation = [orientationVal intValue];
        }
        
        CGFloat scale  = 1;
        UIImage* image = [UIImage
                          imageWithCGImage:[representation fullResolutionImage]
                          scale:scale orientation:orientation];
        photo.mPhoto = image;
        
        [self.arrPhotos addObject:photo];
    }
    [self arrDocument_AddButton];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.collection reloadData];
}

- (void)assetsPickerControllerDidCancel:(CTAssetsPickerController *)picker;
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}



- (UIImage*)makeIcon:(ALAsset*)asset size:(CGSize)size
{
    //подгрузка thumbnail
    CGImageRef iref = [asset thumbnail];
    UIImage *imageData = [UIImage imageWithCGImage:iref];
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    
    // Add a clip before drawing anything, in the shape of an rounded rect
    //    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:10] addClip];
    [imageData drawInRect:rect];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark collection

- (void)collectDelImage:(UIButton*)btn
{
    CGPoint buttonPosition = [btn convertPoint:CGPointZero toView:self.collection];
    NSIndexPath *indexPath = [self.collection indexPathForItemAtPoint:buttonPosition];
    if (indexPath == nil)
        return;
    
    if (indexPath.item < self.arrPhotos.count)
    {
        [self.arrPhotos removeObjectAtIndex:indexPath.item];
        [self.collection deleteItemsAtIndexPaths:@[indexPath]];
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrPhotos.count;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 4.0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize cgSize = CGSizeMake(90, collectionView.bounds.size.height);
    return cgSize;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identCollectCell forIndexPath:indexPath];
    if (indexPath.item >= self.arrPhotos.count)
        return cell;
    
    PhotoModel *photo = self.arrPhotos[indexPath.item];
    
    UIImageView *imgView = (UIImageView*)[cell viewWithTag:10];
    UILabel *docName = (UILabel*)[cell viewWithTag:30];
    UIButton *btnDel = (UIButton*)[cell viewWithTag:20];
    
    if (photo.isButton) {
        //кнопка +
        UIImage *img = [UIImage imageNamed:@"icon_plus.png"];
        imgView.image = img;
        imgView.layer.borderColor = [UIColor colorWithWhite:0.0 alpha:0.4].CGColor;
        
        btnDel.hidden = YES;
        docName.hidden = YES;
    }
    else if(photo.mAsset != nil){
        //вновь добавленные документы
        imgView.image = [self makeIcon:photo.mAsset size:cell.bounds.size];
        imgView.layer.borderColor = [UIColor colorFromHex:0x269afc].CGColor;
        
        btnDel.hidden = NO;
        btnDel.layer.cornerRadius = btnDel.frame.size.width/2;
        docName.hidden = NO;
    } else if (photo.mPhoto != nil) {
        imgView.image = photo.mPhoto;
        imgView.layer.borderColor = [UIColor colorFromHex:0x269afc].CGColor;
        
        btnDel.hidden = NO;
        btnDel.layer.cornerRadius = btnDel.frame.size.width/2;
        docName.hidden = NO;
    }
        
    imgView.layer.cornerRadius = 10.0;
    imgView.layer.borderWidth  = 1.0;
    
    if ([btnDel allTargets].count <= 0)
        [btnDel addTarget:self action:@selector(collectDelImage:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)customViewExample {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    hud.mode = MBProgressHUDModeCustomView;
    UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    hud.customView = [[UIImageView alloc] initWithImage:image];
    hud.square = YES;
    hud.label.text = NSLocalizedString(@"Готово", @"HUD done title");
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if (indexPath.item >= self.arrPhotos.count)
        return;
    
    PhotoModel *photo = self.arrPhotos[indexPath.item];
    if (photo.isButton)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeEventData" object:nil userInfo:@{@"object":self}];
        [self photoChoose];
        
        UIAlertController *vc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        [vc addAction:[UIAlertAction actionWithTitle:@"Выбрать из галереи" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self photoChoose];
        }]];
        
        [vc addAction:[UIAlertAction actionWithTitle:@"Сделать фото" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [vc addAction:[UIAlertAction actionWithTitle:@"Отмена" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [self.navigationController presentViewController:vc animated:YES completion:nil];
    }
}

#pragma mark -

- (IBAction)chooseAction:(id)sender {
    NSMutableArray *arr = [NSMutableArray new];
    
    for (PhotoModel *model in self.arrPhotos)
        if (model.mPhoto)
            [arr addObject:model.mPhoto];

    
    [self stitch:arr];
}

//TODO: Если не пришла картинка
- (void)stitch:(NSArray *)arrImages {
    
    [IOManager stitchImgs:arrImages andBlockComplete:^(BOOL isSucces, NSString *errStr, UIImage *imageStitch) {
        [self.imageView removeFromSuperview];
        [self stopRefreshAnimation];
        //TODO: ???
        if (imageStitch == nil) {
            [self showAlertWithText:@"Не удалось найти общие точки"];
            return;
        }
        
        self.imageStitch = imageStitch;
        
        self.imageView = [[UIImageView alloc] initWithImage:imageStitch];
        
        [self.scrollView addSubview:self.imageView];
        
        self.scrollView.contentSize = self.imageView.bounds.size;
        self.scrollView.maximumZoomScale = 4.0;
        self.scrollView.minimumZoomScale = -1;
        self.scrollView.delegate = self;
        self.scrollView.contentOffset = CGPointMake(-(self.scrollView.bounds.size.width - self.imageView.bounds.size.width)/2.0, -(self.scrollView.bounds.size.height - self.imageView.bounds.size.height)/2.0);
    }];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

@end
