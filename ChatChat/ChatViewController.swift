/* Yi */

import UIKit
import Firebase
import JSQMessagesViewController

class ChatViewController: JSQMessagesViewController {
    
    // MARK: Properties
    var messages = [JSQMessage]() // messages is an array to store the various instances of JSQMessage
    
    
    var outgoingBubbleImageView: JSQMessagesBubbleImage!
    var incomingBubbleImageView: JSQMessagesBubbleImage!
    
    // Firebase
    // In case you’re wondering, creating another reference doesn’t mean you’re creating another connection. Every reference shares the same connection to the same Firebase database.
    let rootRef = Firebase(url: BASE_URL)
    var messageRef = Firebase()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Chatyi"
        setupBubbles()
        
        // No avatars
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSizeZero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero
    
        messageRef = rootRef.childByAppendingPath("messages")
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.observeMessages()
    }
    
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    
    private func setupBubbles() {
        // JSQMessagesBubbleImageFactory has methods that create the images for the chat bubbles. There’s even a category provided by JSQMessagesViewController that creates the message bubble colors used in the native Messages app.
        let factory = JSQMessagesBubbleImageFactory()
        outgoingBubbleImageView = factory.outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleBlueColor())
        incomingBubbleImageView = factory.incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
    }
    

    // MARK: JSQMessagesCollectionView Datasource    
    override func collectionView(collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
            return messages.count
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!,
        messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
            return messages[indexPath.item]
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        let message = messages[indexPath.item] // retrieve the message based on the NSIndexPath item.
        if message.senderId == senderId { // Check if the message was sent by the local user. If so, return the outgoing image view.
            return outgoingBubbleImageView
        } else {  // If the message was not sent by the local user, return the incoming image view.
            return incomingBubbleImageView
        }
    }
    
    // set text color based on who is sending the messages
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        
        let message = messages[indexPath.item]
        
        if message.senderId == senderId {
            cell.textView!.textColor = UIColor.whiteColor()
        } else {
            cell.textView?.textColor = UIColor.blackColor()
        }
        
        
        return cell
    }
    
    
    
    // remove avatar support and close the gap where the avatars would normally get displayed.
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    
    // MARK: - Create Message
    // This helper method creates a new JSQMessage with a blank displayName and adds it to the data source.
    func addMessage(id: String, text: String) {
        let message = JSQMessage(senderId: id, displayName: "", text: text)
        messages.append(message)
    }
    
    // SEND button pressed
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        
        let itemRef = messageRef.childByAutoId() // Using childByAutoId(), you create a child reference with a unique key.
        // Create a dictionary to represent the message. A [String: AnyObject] works as a JSON-like object
        let messageItem = ["text": text, "senderId": senderId]
        
        itemRef.setValue(messageItem) // Save the value at the new child location.
        
        // Play the canonical “message sent” sound.
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        // Complete the “send” action and reset the input toolbar to empty.
        finishSendingMessage()
        
    }
    
    // Observer logic
    private func observeMessages () {
        
        // Start by creating a query that limits the synchronization to the last 25 messages.
        let messagesQuery = messageRef.queryLimitedToLast(25)
        
        
        // Use the .ChildAdded event to observe for every child item that has been added, and will be added, at the messages location.
        messagesQuery.observeEventType(FEventType.ChildAdded) { (snapshot:FDataSnapshot!) -> Void in
            
            // Extract the senderId and text from snapshot.value.
            
            
            
            if let id = snapshot.value["senderId"] as? String, text = snapshot.value["text"] as? String {
                
                // Call addMessage() to add the new message to the data source.
                self.addMessage(id, text: text)
                
                // Inform JSQMessagesViewController that a message has been received.
                self.finishReceivingMessage()
                
                
            }
            
            
            
        }
        
        
    }
    
    
    
}


