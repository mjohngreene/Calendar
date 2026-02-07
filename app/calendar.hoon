/-  *calendar
/+  default-agent, dbug, *calendar
|%
+$  card  card:agent:gall
--
=|  state=versioned-cal-state
=*  st  +.state
%-  agent:dbug
^-  agent:gall
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %.n) bowl)
::
++  on-init
  ^-  (quip card _this)
  ~&  >  '%calendar initialized'
  `this(state [%0 events=~ next-id=0])
::
++  on-save
  ^-  vase
  !>(state)
::
++  on-load
  |=  old-vase=vase
  ^-  (quip card _this)
  ~&  >  '%calendar reloaded'
  =/  old  !<(versioned-cal-state old-vase)
  ?-  -.old
    %0  `this(state old)
  ==
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?>  =(src.bowl our.bowl)
  ?+    mark  (on-poke:def mark vase)
      %calendar-action
    =/  act  !<(action vase)
    ?-    -.act
        %add-event
      =/  res
        (add-event st title.act start.act end.act description.act location.act)
      :_  this(state [%0 +.res])
      :~  [%give %fact ~[/updates] %calendar-update !>([%event-added -.res])]
      ==
        %edit-event
      =/  res
        (edit-event st id.act title.act start.act end.act description.act location.act)
      :_  this(state [%0 +.res])
      :~  [%give %fact ~[/updates] %calendar-update !>([%event-edited -.res])]
      ==
        %delete-event
      =/  new-state  (delete-event st id.act)
      :_  this(state [%0 new-state])
      :~  [%give %fact ~[/updates] %calendar-update !>([%event-deleted id.act])]
      ==
    ==
  ==
::
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?>  =(src.bowl our.bowl)
  ?+    path  (on-watch:def path)
      [%updates ~]
    :_  this
    :~  [%give %fact ~ %calendar-update !>([%init events.st])]
    ==
  ==
::
++  on-peek
  |=  =path
  ^-  (unit (unit cage))
  ?+    path  [~ ~]
      [%x %events ~]
    ``noun+!>(events.st)
      [%x %event @ ~]
    =/  id  (slav %ud i.t.t.path)
    =/  result  (get-event st id)
    ?~  result  [~ ~]
    ``noun+!>(u.result)
      [%x %count ~]
    ``noun+!>(~(wyt by events.st))
  ==
::
++  on-leave  on-leave:def
++  on-agent  on-agent:def
++  on-arvo
  |=  [=wire =sign-arvo]
  ^-  (quip card _this)
  `this
++  on-fail  on-fail:def
--
