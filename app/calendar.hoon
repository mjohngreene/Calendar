/-  *calendar
/+  default-agent, dbug, server, *calendar, calendar-date, calendar-ui
|%
+$  card  card:agent:gall
--
=|  state=versioned-cal-state
=*  st  +.state
%-  agent:dbug
^-  agent:gall
=<
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %.n) bowl)
    hc    ~(. +> bowl)
::
++  on-init
  ^-  (quip card _this)
  ~&  >  '%calendar initialized with web UI'
  :_  this(state [%0 events=~ next-id=0])
  [%pass /eyre %arvo %e %connect [~ /apps/calendar] dap.bowl]~
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
      %0
    :_  this(state old)
    [%pass /eyre %arvo %e %connect [~ /apps/calendar] dap.bowl]~
  ==
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?+    mark  (on-poke:def mark vase)
  ::  existing calendar-action pokes (CLI)
  ::
      %calendar-action
    ?>  =(src.bowl our.bowl)
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
  ::  HTTP request handling
  ::
      %handle-http-request
    =+  !<([eyre-id=@ta =inbound-request:eyre] vase)
    =/  req  request.inbound-request
    =/  rl  (parse-request-line:server url.req)
    ::  strip /apps/calendar prefix from site path
    =/  site=(list @t)
      ?.  ?=([%apps %calendar *] site.rl)
        site.rl
      t.t.site.rl
    ?:  ?=(%'GET' method.req)
      ::  GET: use require-authorization, no state change
      :_  this
      %+  give-simple-payload:app:server  eyre-id
      %+  require-authorization:app:server  inbound-request
      |=  =inbound-request:eyre
      ^-  simple-payload:http
      (handle-get:hc site args.rl)
    ?:  ?=(%'POST' method.req)
      ::  POST: check auth manually, mutate state, return cards
      ?.  authenticated.inbound-request
        :_  this
        %+  give-simple-payload:app:server  eyre-id
        (redirect:gen:server (cat 3 '/~/login?redirect=' url.req))
      ::  parse form body and route
      =/  base-url=tape  "/apps/calendar"
      =/  body-args=(list [key=@t value=@t])
        ?~  body.req  ~
        (parse-form-body:hc q.u.body.req)
      ?+    site
        :_(this (give-simple-payload:app:server eyre-id not-found:gen:server))
      ::  POST /add
      ::
          [%add ~]
        =/  title  (fall (find-arg:hc body-args 'title') '')
        =/  start  (parse-date-time:hc body-args 'start-date' 'start-time')
        =/  end  (parse-date-time:hc body-args 'end-date' 'end-time')
        =/  desc  (find-arg:hc body-args 'description')
        =/  loc  (find-arg:hc body-args 'location')
        =/  desc  ?~(desc ~ ?:(=('' u.desc) ~ desc))
        =/  loc  ?~(loc ~ ?:(=('' u.loc) ~ loc))
        =/  res  (add-event st title start end desc loc)
        =/  s-date  (yore start)
        =/  redir  (crip "{base-url}?m={(ud-to-tape:calendar-ui m.s-date)}&y={(ud-to-tape:calendar-ui y.s-date)}")
        =/  http-cards  (give-simple-payload:app:server eyre-id (redirect:gen:server redir))
        =/  update-card  [%give %fact ~[/updates] %calendar-update !>([%event-added -.res])]
        :_  this(state [%0 +.res])
        (snoc http-cards update-card)
      ::  POST /edit/<id>
      ::
          [%edit @ ~]
        =/  id  (rush i.t.site dem)
        ?~  id
          :_(this (give-simple-payload:app:server eyre-id not-found:gen:server))
        =/  title  (fall (find-arg:hc body-args 'title') '')
        =/  start  (parse-date-time:hc body-args 'start-date' 'start-time')
        =/  end  (parse-date-time:hc body-args 'end-date' 'end-time')
        =/  desc  (find-arg:hc body-args 'description')
        =/  loc  (find-arg:hc body-args 'location')
        =/  desc  ?~(desc ~ ?:(=('' u.desc) ~ desc))
        =/  loc  ?~(loc ~ ?:(=('' u.loc) ~ loc))
        ?.  (~(has by events.st) u.id)
          :_(this (give-simple-payload:app:server eyre-id not-found:gen:server))
        =/  res  (edit-event st u.id title start end desc loc)
        =/  s-date  (yore start)
        =/  redir  (crip "{base-url}?m={(ud-to-tape:calendar-ui m.s-date)}&y={(ud-to-tape:calendar-ui y.s-date)}")
        =/  http-cards  (give-simple-payload:app:server eyre-id (redirect:gen:server redir))
        =/  update-card  [%give %fact ~[/updates] %calendar-update !>([%event-edited -.res])]
        :_  this(state [%0 +.res])
        (snoc http-cards update-card)
      ::  POST /delete/<id>
      ::
          [%delete @ ~]
        =/  id  (rush i.t.site dem)
        ?~  id
          :_(this (give-simple-payload:app:server eyre-id not-found:gen:server))
        ?.  (~(has by events.st) u.id)
          :_(this (give-simple-payload:app:server eyre-id not-found:gen:server))
        =/  new-state  (delete-event st u.id)
        =/  redir  (crip base-url)
        =/  http-cards  (give-simple-payload:app:server eyre-id (redirect:gen:server redir))
        =/  update-card  [%give %fact ~[/updates] %calendar-update !>([%event-deleted u.id])]
        :_  this(state [%0 new-state])
        (snoc http-cards update-card)
      ==
    :_  this
    (give-simple-payload:app:server eyre-id not-found:gen:server)
  ==
::
++  on-watch
  |=  =path
  ^-  (quip card _this)
  ?+    path  (on-watch:def path)
      [%updates ~]
    ?>  =(src.bowl our.bowl)
    :_  this
    :~  [%give %fact ~ %calendar-update !>([%init events.st])]
    ==
      [%http-response *]
    [~ this]
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
  ?.  ?=([%eyre %bound *] sign-arvo)
    `this
  ~?  !accepted.sign-arvo
    [dap.bowl "bind rejected!" binding.sign-arvo]
  `this
++  on-fail  on-fail:def
--
::  helper core: pure functions for HTTP handling
::
|_  =bowl:gall
::
++  handle-get
  |=  [site=(list @t) args=(list [key=@t value=@t])]
  ^-  simple-payload:http
  =/  base-url=tape  "/apps/calendar"
  ?+    site  not-found:gen:server
      ~
    =/  cur  (yore now.bowl)
    =/  y=@ud  (fall (bind (find-arg args 'y') |=(v=@t (rash v dem))) y.cur)
    =/  m=@ud  (fall (bind (find-arg args 'm') |=(v=@t (rash v dem))) m.cur)
    %-  manx-response:gen:server
    (render-month-view:calendar-ui y m events.st base-url now.bowl)
  ::
      [%add ~]
    =/  cur  (yore now.bowl)
    =/  y=@ud  (fall (bind (find-arg args 'y') |=(v=@t (rash v dem))) y.cur)
    =/  m=@ud  (fall (bind (find-arg args 'm') |=(v=@t (rash v dem))) m.cur)
    %-  manx-response:gen:server
    (render-add-form:calendar-ui y m base-url)
  ::
      [%edit @ ~]
    =/  id  (rush i.t.site dem)
    ?~  id  not-found:gen:server
    =/  ev  (get-event st u.id)
    ?~  ev  not-found:gen:server
    %-  manx-response:gen:server
    (render-edit-form:calendar-ui u.ev base-url)
  ::
      [%event @ ~]
    =/  id  (rush i.t.site dem)
    ?~  id  not-found:gen:server
    =/  ev  (get-event st u.id)
    ?~  ev  not-found:gen:server
    %-  manx-response:gen:server
    (render-event-detail:calendar-ui u.ev base-url)
  ==
::
++  parse-form-body
  |=  body=@t
  ^-  (list [key=@t value=@t])
  =/  query  (cat 3 '?' body)
  (fall (rush query yque:de-purl:html) ~)
::
++  parse-date-time
  |=  [args=(list [key=@t value=@t]) date-key=@t time-key=@t]
  ^-  @da
  =/  date-str  (fall (find-arg args date-key) '2025-01-01')
  =/  time-str  (fall (find-arg args time-key) '00:00')
  ::  parse YYYY-MM-DD
  =/  dp=(list @t)  (split-cord date-str '-')
  =/  y=@ud
    ?~  dp  2.025
    (rash i.dp dem)
  =/  m=@ud
    ?~  dp  1
    ?~  t.dp  1
    (rash i.t.dp dem)
  =/  d=@ud
    ?~  dp  1
    ?~  t.dp  1
    ?~  t.t.dp  1
    (rash i.t.t.dp dem)
  ::  parse HH:MM
  =/  tp=(list @t)  (split-cord time-str ':')
  =/  h=@ud
    ?~  tp  0
    (rash i.tp dem)
  =/  min=@ud
    ?~  tp  0
    ?~  t.tp  0
    (rash i.t.tp dem)
  (year [[& y] m d h min 0 ~])
::
++  find-arg
  |=  [args=(list [key=@t value=@t]) key=@t]
  ^-  (unit @t)
  =/  matches  (skim args |=([k=@t v=@t] =(k key)))
  ?~  matches  ~
  `value.i.matches
::
++  split-cord
  |=  [txt=@t del=@t]
  ^-  (list @t)
  =/  chars=(list @t)  (rip 3 txt)
  =/  del-char=@t  del
  =/  current=(list @t)  ~
  =/  result=(list (list @t))  ~
  |-
  ?~  chars
    =/  final  (flop [current result])
    %+  turn  final
    |=(cs=(list @t) (rap 3 (flop cs)))
  ?:  =(i.chars del-char)
    $(chars t.chars, result [current result], current ~)
  $(chars t.chars, current [i.chars current])
--
