//
//  ViewController.m
//  AsyncSocketDemo
//
//  Created by Wingle Wong on 6/19/13.
//  Copyright (c) 2013 Wingle Wong. All rights reserved.
//

#import "ViewController.h"
#import "GCDAsyncSocket.h"

static BOOL isStarting = NO;

@interface ViewController () {
    GCDAsyncSocket *socket;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    if (socket == nil) {
        socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    isStarting = [socket isConnected];
    
    if (isStarting) {
        self.hostTextField.enabled = NO;
        self.portTextField.enabled = NO;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - ib action methods
- (IBAction)swithBtnClicked:(id)sender {
    if ([socket isConnected]) {
        [socket disconnect];
        return;
    }
    
    if (self.hostTextField.text == nil || self.portTextField.text == nil) {
        self.hostTextField.enabled = YES;
        self.portTextField.enabled = YES;
        return;
    }
    [self.statusLabel setText:@"Connecting ..."];
    NSString *host = self.hostTextField.text;
    uint16_t port = [self.portTextField.text intValue];
    
    NSError *error = nil;
    if (![socket connectToHost:host onPort:port error:&error]) {
        [self.statusLabel setText:@"Oops..."];
        return;
    }
    self.hostTextField.enabled = NO;
    self.portTextField.enabled = NO;
    [socket readDataWithTimeout:-1 tag:0];

}

- (IBAction)sendMessage:(id)sender {
    if (self.sendMsgTextField.text == nil) {
        return;
    }
    NSString *msg = [NSString stringWithFormat:@"%@\r\n", self.sendMsgTextField.text];
    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    
    [socket writeData:data withTimeout:-1 tag:0];
    [self.sendMsgTextField resignFirstResponder];
    
}

#pragma mark - socket delegate methods
/**
 * Called when a socket connects and is ready for reading and writing.
 * The host parameter will be an IP address, not a DNS name.
 **/
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    NSLog(@"Connected .");
    isStarting = YES;
    [self.statusLabel setText:@"Connected"];
    [self.swithBtn setTitle:@"Stop" forState:UIControlStateNormal];  
    
}

/**
 * Called when a socket has completed reading the requested data into memory.
 * Not called if there is an error.
 **/
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self.incomeMessageTextView setText:msg];
    [socket readDataWithTimeout:-1 tag:0];
    NSLog(@"Read . tag = %ld, msg = %@",tag,msg);
    
}

/**
 * Called when a socket has completed writing the requested data. Not called if there is an error.
 **/
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    NSLog(@"send . tag = %ld",tag);
    
}


/**
 * Called when a socket disconnects with or without error.
 *
 * If you call the disconnect method, and the socket wasn't already disconnected,
 * this delegate method will be called before the disconnect method returns.
 **/
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    NSLog(@"Disconnected .");
    isStarting = NO;
    self.hostTextField.enabled = YES;
    self.portTextField.enabled = YES;
    [self.statusLabel setText:@"Disconnected"];
    [self.swithBtn setTitle:@"Start" forState:UIControlStateNormal];
    
}






@end
