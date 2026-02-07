/-  *calendar
/+  *calendar
:-  %say
|=  $:  [now=@da eny=@uvJ bec=beak]
        ~
        [start=@da end=@da ~]
    ==
:-  %noun
=/  all-events=(map @ud event)
  .^((map @ud event) %gx /(scot %p p.bec)/calendar/(scot %da now)/events/noun)
=/  event-list=(list event)
  %+  turn  ~(tap by all-events)
  |=([=@ud =event] event)
=/  filtered=(list event)
  ?.  =(start *@da)
    %+  skim  event-list
    |=(=event &((gte start.event start) (lth start.event end)))
  event-list
=/  sorted=(list event)
  %+  sort  filtered
  |=([a=event b=event] (lth start.a start.b))
?~  sorted
  ~&  >  'No events found.'
  ~
~&  >  "Found {<(lent sorted)>} event(s):"
%+  turn  sorted
|=  =event
~&  >  "---"
~&  >  "  ID:    {<id.event>}"
~&  >  "  Title: {<title.event>}"
~&  >  "  Start: {<start.event>}"
~&  >  "  End:   {<end.event>}"
?^  description.event  ~&  >  "  Desc:  {<u.description.event>}"  ~
?^  location.event     ~&  >  "  Loc:   {<u.location.event>}"  ~
event
