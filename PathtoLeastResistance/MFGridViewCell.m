
#import "MFGridViewCell.h"

#import "MFGridViewIndex.h"

static NSUInteger GridViewCellInstanceCount = 0;

@implementation MFGridViewCell
@synthesize index = _index;
@synthesize input;

- (void)dealloc
{
    --GridViewCellInstanceCount;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GridViewCellInstanceCountChanged" 
                                                        object:[NSNumber numberWithUnsignedInteger:GridViewCellInstanceCount]];

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self != nil) {
        ++GridViewCellInstanceCount;

        [[NSNotificationCenter defaultCenter] postNotificationName:@"GridViewCellInstanceCountChanged" 
                                                            object:[NSNumber numberWithUnsignedInteger:GridViewCellInstanceCount]];
        
        _index = nil;
    }

    return self;
}

@end
