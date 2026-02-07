/-  *calendar
:-  %say
|=  $:  [now=@da eny=@uvJ bec=beak]
        [title=@t start=@da end=@da ~]
        [description=@t location=@t ~]
    ==
:-  %calendar-action
=/  desc=(unit @t)  ?:(=(description '') ~ `description)
=/  loc=(unit @t)   ?:(=(location '') ~ `location)
[%add-event title start end desc loc]
