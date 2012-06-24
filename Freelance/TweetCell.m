//
//  SimpleTableCell.m
//  Freelance
//
//  Created by Miquel Camps Ortea on 25/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TweetCell.h"

#import "UIImageView+WebCache.h"

@interface TweetCell()

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *prepTimeLabel;
@property (nonatomic, weak) IBOutlet UIImageView *thumbnailImageView;

@end

@implementation TweetCell

@synthesize nameLabel = _nameLabel;
@synthesize prepTimeLabel = _prepTimeLabel;
@synthesize thumbnailImageView = _thumbnailImageView;

- (void)setTweet:(NSDictionary *)tweet
{
    [self.thumbnailImageView setImageWithURL:[NSURL URLWithString:[tweet objectForKey:@"profile_image_url"]]  placeholderImage:[UIImage imageNamed:@"twitter.png"]];
    
	self.nameLabel.text = [tweet objectForKey:@"from_user"];

    self.prepTimeLabel.text = [tweet objectForKey:@"text"];
}

@end
