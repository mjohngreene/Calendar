/-  *calendar
/+  *calendar
:-  %say
|=  [[now=@da eny=@uvJ bec=beak] ~ ~]
:-  %noun
=/  results=(list [name=@t pass=?])
  :~
  :_  ^-  ?
      =/  e  (make-event 0 'Test' ~2025.1.1 ~2025.1.2 ~ ~)
      &(=(id.e 0) =(title.e 'Test') =(description.e ~))
    'make-event: basic'
  ::
  :_  ^-  ?
      =/  e  (make-event 5 'Full' ~2025.3.1 ~2025.3.2 `'Desc' `'Loc')
      &(=(id.e 5) =(description.e `'Desc') =(location.e `'Loc'))
    'make-event: with optionals'
  ::
  :_  ^-  ?
      =/  s0  *cal-state
      =/  [e=event s1=cal-state]  (add-event s0 'First' ~2025.1.1 ~2025.1.2 ~ ~)
      &(=(id.e 0) =(next-id.s1 1) =(~(wyt by events.s1) 1))
    'add-event: first event gets id 0'
  ::
  :_  ^-  ?
      =/  s0  *cal-state
      =/  [e1=event s1=cal-state]  (add-event s0 'First' ~2025.1.1 ~2025.1.2 ~ ~)
      =/  [e2=event s2=cal-state]  (add-event s1 'Second' ~2025.2.1 ~2025.2.2 ~ ~)
      &(=(id.e1 0) =(id.e2 1) =(next-id.s2 2) =(~(wyt by events.s2) 2))
    'add-event: sequential IDs'
  ::
  :_  ^-  ?
      =/  s0  *cal-state
      =/  [e=event s1=cal-state]  (add-event s0 'Original' ~2025.1.1 ~2025.1.2 ~ ~)
      =/  [edited=event s2=cal-state]  (edit-event s1 0 'Updated' ~2025.2.1 ~2025.2.2 `'Desc' ~)
      &(=(title.edited 'Updated') =(description.edited `'Desc') =(~(wyt by events.s2) 1))
    'edit-event: updates fields'
  ::
  :_  ^-  ?
      =/  s0  *cal-state
      =/  [e=event s1=cal-state]  (add-event s0 'ToDelete' ~2025.1.1 ~2025.1.2 ~ ~)
      =/  s2  (delete-event s1 0)
      =(~(wyt by events.s2) 0)
    'delete-event: removes event'
  ::
  :_  ^-  ?
      =/  s0  *cal-state
      =/  [e=event s1=cal-state]  (add-event s0 'Find Me' ~2025.1.1 ~2025.1.2 ~ ~)
      =/  result  (get-event s1 0)
      &(?=(^ result) =(title.u.result 'Find Me'))
    'get-event: finds existing'
  ::
  :_  ^-  ?
      =(~ (get-event *cal-state 99))
    'get-event: returns ~ for missing'
  ::
  :_  ^-  ?
      =/  s0  *cal-state
      =/  [e1=event s1=cal-state]  (add-event s0 'A' ~2025.1.1 ~2025.1.2 ~ ~)
      =/  [e2=event s2=cal-state]  (add-event s1 'B' ~2025.2.1 ~2025.2.2 ~ ~)
      =((lent (list-events s2)) 2)
    'list-events: returns all'
  ::
  :_  ^-  ?
      =((lent (list-events *cal-state)) 0)
    'list-events: empty state'
  ::
  :_  ^-  ?
      =/  s0  *cal-state
      =/  [e1=event s1=cal-state]  (add-event s0 'Jan' ~2025.1.15 ~2025.1.16 ~ ~)
      =/  [e2=event s2=cal-state]  (add-event s1 'Feb' ~2025.2.15 ~2025.2.16 ~ ~)
      =/  [e3=event s3=cal-state]  (add-event s2 'Mar' ~2025.3.15 ~2025.3.16 ~ ~)
      =/  result  (events-in-range s3 ~2025.2.1 ~2025.3.1)
      &(=((lent result) 1) =(title:(snag 0 result) 'Feb'))
    'events-in-range: filters correctly'
  ==
=/  passed  (lent (skim results |=([n=@t p=?] p)))
=/  failed  (lent (skip results |=([n=@t p=?] p)))
=/  total   (lent results)
~&  >  "=== Calendar Test Results ==="
~&  >  "{<passed>} passed, {<failed>} failed, {<total>} total"
%+  turn  results
|=  [name=@t pass=?]
?:  pass
  ~&  >  "  PASS: {<name>}"
  [name pass]
~&  >>>  "  FAIL: {<name>}"
[name pass]
