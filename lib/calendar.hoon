/-  *calendar
|%
++  make-event
  |=  [id=@ud title=@t start=@da end=@da description=(unit @t) location=(unit @t)]
  ^-  event
  [id=id title=title start=start end=end description=description location=location]
::
++  add-event
  |=  [=cal-state title=@t start=@da end=@da description=(unit @t) location=(unit @t)]
  =/  id  next-id.cal-state
  =/  =event  (make-event id title start end description location)
  :-  event
  cal-state(events (~(put by events.cal-state) id event), next-id +(next-id.cal-state))
::
++  edit-event
  |=  [=cal-state id=@ud title=@t start=@da end=@da description=(unit @t) location=(unit @t)]
  ?>  (~(has by events.cal-state) id)
  =/  =event  (make-event id title start end description location)
  :-  event
  cal-state(events (~(put by events.cal-state) id event))
::
++  delete-event
  |=  [=cal-state id=@ud]
  ?>  (~(has by events.cal-state) id)
  cal-state(events (~(del by events.cal-state) id))
::
++  get-event
  |=  [=cal-state id=@ud]
  ^-  (unit event)
  (~(get by events.cal-state) id)
::
++  list-events
  |=  =cal-state
  ^-  (list event)
  %+  turn  ~(tap by events.cal-state)
  |=([=@ud =event] event)
::
++  events-in-range
  |=  [=cal-state range-start=@da range-end=@da]
  ^-  (list event)
  %+  skim  (list-events cal-state)
  |=(=event &((lth start.event range-end) (gth end.event range-start)))
--
