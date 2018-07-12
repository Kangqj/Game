//
//  SnakeBody.m
//  Snakes
//
//  Created by Li Xiaolei on 2017/6/29.
//  Copyright © 2017年 Li Xiaolei. All rights reserved.
//

#import "SnakeBody.h"
#import "SnakeNode.h"
@interface SnakeBody()
@property (nonatomic,strong) CADisplayLink *link;
@property (nonatomic,strong) NSMutableArray<SnakeNode*> *nodes;
@property (nonatomic,strong) UIColor *m_color;

@end
@implementation SnakeBody

-(instancetype)initWithView:(UIView*)backView{
    if (self = [super init]) {
        self.backView = backView;
        self.nodes = [NSMutableArray array];
        self.nodeWidth = 20;
        self.isMoving = NO;
        [self reLife];
        self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(moveForward)];
        [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        
        self.m_color = [UIColor blackColor];
    }
    return self;
}

-(void)reLife{
    [self.nodes enumerateObjectsUsingBlock:^(SnakeNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self.nodes removeAllObjects];
    self.side = CGPointMake(0, 1);
    [self eatFoodCount:10 color:self.m_color];
}

-(void)runSnakeCount:(int)count color:(UIColor *)color {
    for (int i=0; i<count; i++) {
        SnakeNode *first = self.nodes.firstObject;
        CGPoint p = first.center;
        if (!first) {
            p=CGPointMake(200, 100);//初始位置
        }
        SnakeNode *n = [[SnakeNode alloc] initWithFrame:CGRectMake(0, 0, self.nodeWidth, self.nodeWidth)];
        p.x+=(self.side.x*self.nodeWidth/10);
        p.y+=(self.side.y*self.nodeWidth/10);
        n.center = p;
//        n.backgroundColor = color;
        [_backView addSubview:n];
        [self.nodes insertObject:n atIndex:0];
    }
}

-(void)eatFoodCount:(int)count color:(UIColor *)color {
    for (int i=0; i<count; i++) {
        SnakeNode *first = self.nodes.lastObject;
        CGPoint p = first.center;
        if (!first) {
            p=CGPointMake(200, 100);//初始位置
        }
        SnakeNode *n = [[SnakeNode alloc] initWithFrame:CGRectMake(0, 0, self.nodeWidth, self.nodeWidth)];
        p.x+=(self.side.x*self.nodeWidth/10);
        p.y+=(self.side.y*self.nodeWidth/10);
        n.center = p;
        //        n.backgroundColor = color;
        [_backView addSubview:n];
        [self.nodes addObject:n];
    }
}

-(void)moveForward{
    if (!self.isMoving) {
        return;
    }
    
    UIColor *color = self.m_color;
    if (self.nodes.count > 0)
    {
        SnakeNode *first = self.nodes.lastObject;
        color = first.backgroundColor;
    }
    
    [self runSnakeCount:1 color:color];//先将第一个节点向前走一步，再删除最后的一个节点
    [self.nodes.lastObject removeFromSuperview];
    [self.nodes removeLastObject];
    SnakeNode *first = self.nodes.firstObject;
    [self.delegate snakeDidMove2Frame:first.frame];
}
-(void)setSide:(CGPoint)side{
    CGFloat s = sqrt(side.x*side.x+side.y*side.y);
    if (s>0.001) {
        side.x/=s;
        side.y/=s;
    }
    _side = side;
}

- (void)paused:(BOOL)paused
{
    self.link.paused = paused;
}

@end
