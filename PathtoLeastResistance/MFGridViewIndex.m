
#import "MFGridViewIndex.h"

@implementation MFGridViewIndex
@synthesize row = _row;
@synthesize column = _column;

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ row = %lu column = %lu", [super description], (unsigned long)_row, (unsigned long)_column];
}

@end
