|%
+$  event
  $:  id=@ud
      title=@t
      start=@da
      end=@da
      description=(unit @t)
      location=(unit @t)
  ==
::
+$  action
  $%  [%add-event title=@t start=@da end=@da description=(unit @t) location=(unit @t)]
      [%edit-event id=@ud title=@t start=@da end=@da description=(unit @t) location=(unit @t)]
      [%delete-event id=@ud]
  ==
::
+$  update
  $%  [%event-added =event]
      [%event-edited =event]
      [%event-deleted id=@ud]
      [%init events=(map @ud event)]
  ==
::
+$  state-0
  $:  events=(map @ud event)
      next-id=@ud
  ==
::
+$  versioned-state
  $%  [%0 state-0]
  ==
--
