'entity with 8 boxes
'each box has an action associated with it
	'open
	'close
	'pull
	'push
	'get
	'use
	'lookAt
	'talkTo
'detect right click
'if pointing at an entity
'add actions entity to screen
'after player clicks on one, add an always/deleteAfter event to the game that has an action that reflects the action the player performs.  this can hit listeners the scriptwriter can code into events

'new event as playerAction([listener])
'new event as playerAction(entity1 open entity2)
'new ev1 give entity2 to entity3)
'new event as playerAction(entity1 use entity2)
'new event as playerAction(entity1 talkTo entity3)
'new event as playerAction(entity1 lookAt entity2)
'new event as playerAction(entity1 pull entity2)
'new event as playerAction(entity1 push entity2)
'new event as playerAction(entity1 get entity2)
'new event as playerAction(entity1 get entity3)

'these actions will only have any effect if the script writer has an event to catch the action.
        &� c  Z  ( 2 ) . 