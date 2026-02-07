/-  *calendar
|%
++  make-event
  |=  [id=@ud title=@t start=@da end=@da description=(unit @t) location=(unit @t)]
  ^-  event
  [id=id title=title start=start end=end description=description location=location]
::
++  add-event
  |=  [=state-0 title=@t start=@da end=@da description=(unit @t) location=(unit @t)]
  ^-  [event state-0]
  =/  id  next-id.state-0
  =/  =event  (make-event id title start end description location)
  :-  event
  state-0(events (~(put by events.state-0) id event), next-id +(next-id.state-0))
::
++  edit-event
  |=  [=state-0 id=@ud title=@t start=@da end=@da description=(unit @t) location=(unit @t)]
  ^-  [event state-0]
  ?>  (~(has by events.state-0) id)
  =/  =event  (make-event id title start end description location)
  :-  event
  state-0(events (~(put by events.state-0) id event))
::
++  delete-event
  |=  [=state-0 id=@ud]
  ^-  state-0
  ?>  (~(has by events.state-0) id)
  state-0(events (~(del by events.state-0) id))
::
++  get-event
  |=  [=state-0 id=@ud]
  ^-  (unit event)
  (~(get by events.state-0) id)
::
++  list-events
  |=  =state-0
  ^-  (list event)
  %+  turn  ~(tap by events.state-0)
  |=([=@ud =event] event)
::
++  events-in-range
  |=  [=state-0 range-start=@da range-end=@da]
  ^-  (list event)
  %+  skim  (list-events state-0)
  |=(=event &((lth start.event range-end) (gth end.event range-start)))
--
