/+  *calendar-date
:-  %say
|=  [[now=@da eny=@uvJ bec=beak] ~ ~]
:-  %noun
=/  results=(list [name=@t pass=?])
  :~
  ::  day-of-week tests
  ::  ~2025.1.1 = Wednesday = 3
  :_  ^-  ?
      =((day-of-week ~2025.1.1) 3)
    'day-of-week: 2025-01-01 is Wednesday (3)'
  ::  ~2025.1.5 = Sunday = 0
  :_  ^-  ?
      =((day-of-week ~2025.1.5) 0)
    'day-of-week: 2025-01-05 is Sunday (0)'
  ::  ~2025.1.6 = Monday = 1
  :_  ^-  ?
      =((day-of-week ~2025.1.6) 1)
    'day-of-week: 2025-01-06 is Monday (1)'
  ::  ~2025.6.14 = Saturday = 6
  :_  ^-  ?
      =((day-of-week ~2025.6.14) 6)
    'day-of-week: 2025-06-14 is Saturday (6)'
  ::  days-in-month tests
  :_  ^-  ?
      =((days-in-month 2.025 1) 31)
    'days-in-month: January has 31'
  :_  ^-  ?
      =((days-in-month 2.025 2) 28)
    'days-in-month: Feb 2025 (non-leap) has 28'
  :_  ^-  ?
      =((days-in-month 2.024 2) 29)
    'days-in-month: Feb 2024 (leap) has 29'
  :_  ^-  ?
      =((days-in-month 2.000 2) 29)
    'days-in-month: Feb 2000 (400-leap) has 29'
  :_  ^-  ?
      =((days-in-month 1.900 2) 28)
    'days-in-month: Feb 1900 (100-non-leap) has 28'
  :_  ^-  ?
      =((days-in-month 2.025 4) 30)
    'days-in-month: April has 30'
  :_  ^-  ?
      =((days-in-month 2.025 12) 31)
    'days-in-month: December has 31'
  ::  leap-year tests
  :_  ^-  ?
      (leap-year 2.024)
    'leap-year: 2024 is leap'
  :_  ^-  ?
      !(leap-year 2.025)
    'leap-year: 2025 is not leap'
  :_  ^-  ?
      (leap-year 2.000)
    'leap-year: 2000 is leap (div 400)'
  :_  ^-  ?
      !(leap-year 1.900)
    'leap-year: 1900 is not leap (div 100)'
  ::  prev-month / next-month boundary tests
  :_  ^-  ?
      =((prev-month 2.025 1) [2.024 12])
    'prev-month: Jan 2025 -> Dec 2024'
  :_  ^-  ?
      =((prev-month 2.025 6) [2.025 5])
    'prev-month: Jun -> May'
  :_  ^-  ?
      =((next-month 2.025 12) [2.026 1])
    'next-month: Dec 2025 -> Jan 2026'
  :_  ^-  ?
      =((next-month 2.025 6) [2.025 7])
    'next-month: Jun -> Jul'
  ::  month-name tests
  :_  ^-  ?
      =((month-name 1) 'January')
    'month-name: 1 is January'
  :_  ^-  ?
      =((month-name 12) 'December')
    'month-name: 12 is December'
  ==
=/  passed  (lent (skim results |=([n=@t p=?] p)))
=/  failed  (lent (skip results |=([n=@t p=?] p)))
=/  total   (lent results)
~&  >  "=== Calendar Date Test Results ==="
~&  >  "{<passed>} passed, {<failed>} failed, {<total>} total"
%+  turn  results
|=  [name=@t pass=?]
?:  pass
  ~&  >  "  PASS: {<name>}"
  [name pass]
~&  >>>  "  FAIL: {<name>}"
[name pass]
