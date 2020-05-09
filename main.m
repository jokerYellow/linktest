#import <Foundation/Foundation.h>
#import "foo.h"
 
int main(int argc, char const *argv[])
{ 
    NSLog(@"%@",[[Foo new] name]);
    return 0;
}
