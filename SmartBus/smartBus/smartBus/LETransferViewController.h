//
//  LETransferViewController.h
//  smartBus
//
//  Created by Eda on 2017/4/27.
//  Copyright © 2017年 Eda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEStopSearchButton.h"
#import "LETransferSearchController.h"
@interface LETransferViewController : UIViewController
@property (weak, nonatomic) IBOutlet LEStopSearchButton *origin;
@property (weak, nonatomic) IBOutlet LEStopSearchButton *terminal;
@end
