::  lib/calendar-date.hoon: date arithmetic for calendar month grid
::
|%
::  +day-of-week: @da -> 0=Sun..6=Sat (Sakamoto's algorithm)
::
++  day-of-week
  |=  d=@da
  ^-  @ud
  =/  date  (yore d)
  =/  y=@ud  y.date
  =/  m=@ud  m.date
  =/  day=@ud  d.t.date
  ::  adjust year for Jan/Feb
  =?  y  (lth m 3)  (dec y)
  =/  table=(list @ud)  ~[0 3 2 5 0 3 5 1 4 6 2 4]
  =/  t=@ud  (snag (dec m) table)
  ::  formula: (y + y/4 - y/100 + y/400 + t + d) mod 7
  ::  add 700 (multiple of 7) to avoid atom underflow on subtraction
  =/  sum  (add (add (add (add (add y (div y 4)) 700) (div y 400)) t) day)
  (mod (sub sum (div y 100)) 7)
::  +days-in-month: [year month] -> number of days
::
++  days-in-month
  |=  [y=@ud m=@ud]
  ^-  @ud
  ?+  m  30
    %1   31
    %2   ?:((leap-year y) 29 28)
    %3   31
    %4   30
    %5   31
    %6   30
    %7   31
    %8   31
    %9   30
    %10  31
    %11  30
    %12  31
  ==
::  +leap-year: is year a leap year?
::
++  leap-year
  |=  y=@ud
  ^-  ?
  ?:  =(0 (mod y 400))  %.y
  ?:  =(0 (mod y 100))  %.n
  =(0 (mod y 4))
::  +month-start-da: first moment of month as @da
::
++  month-start-da
  |=  [y=@ud m=@ud]
  ^-  @da
  (year [[& y] m 1 0 0 0 ~])
::  +month-end-da: first moment after month ends as @da
::
++  month-end-da
  |=  [y=@ud m=@ud]
  ^-  @da
  =/  [ny=@ud nm=@ud]  (next-month y m)
  (year [[& ny] nm 1 0 0 0 ~])
::  +prev-month: [year month] -> previous [year month]
::
++  prev-month
  |=  [y=@ud m=@ud]
  ^-  [y=@ud m=@ud]
  ?:  =(m 1)
    [(dec y) 12]
  [y (dec m)]
::  +next-month: [year month] -> next [year month]
::
++  next-month
  |=  [y=@ud m=@ud]
  ^-  [y=@ud m=@ud]
  ?:  =(m 12)
    [+(y) 1]
  [y +(m)]
::  +month-name: month number -> cord
::
++  month-name
  |=  m=@ud
  ^-  @t
  =/  names=(list @t)
    ~['January' 'February' 'March' 'April' 'May' 'June' 'July' 'August' 'September' 'October' 'November' 'December']
  (snag (dec m) names)
--
