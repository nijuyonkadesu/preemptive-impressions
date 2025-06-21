# tl;dr

1. get the `bot`
2. get the `update`
3. get the `dispatcher`
4. get the `handler` -> define a function to handle a particular message event from tg
5. start the bot by long polling or by webhook

[sample](https://github.com/PaulSonOfLars/gotgbot/blob/v2/samples/callbackqueryBot/main.go)

# Disect

## Basics

1. handler - For a new message the Bot recieves, for a new poll the bot receives

   - generally takes in a event `filter` and an user-defined-handler-function
   - atomic unit
     - exception: `handler.NewConversation` -> like those bots which asks to subscribe a channel / ask to pay

2. dispatchers - add the above event handlers to Dispatcher groups -> uses handlers to process events

   - to group different handlers into a group
   - stack different groups one after the other
   - determine the order of execution based on the stack order
   - routers

**After dispatching the event**

3. ctx
   - all information regarding the update can be fetched from here. fields can be nil.

4. bot
   - used to send replies or perform any bot actions

### Example

```lua
 Dispatcher receives Update
 ├─ Group -10: [authHandler]
 ├─ Group 0  : [NewCommand("/start"), NewMessage(textFilter)]
 ├─ Group 10 : [NewConversation(), stateHandlers, etc.]
 └─ (handlers run in order, if they match)
```

## Advanced

1. [*] Processors for dispatchers are needed? - when does it make sense
