::  lib/calendar-ui.hoon: Sail HTML rendering for calendar GUI
::
/-  *calendar
/+  calendar-date
|%
::  +page-wrapper: wrap content manx in full HTML page with inline CSS
::
++  page-wrapper
  |=  [title=tape content=manx]
  ^-  manx
  ;html
    ;head
      ;meta(charset "utf-8");
      ;meta(name "viewport", content "width=device-width, initial-scale=1");
      ;title: {title}
      ;style
        ;+  ;/  %-  trip
        '''
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif; background: #f5f5f5; color: #333; padding: 20px; max-width: 960px; margin: 0 auto; }
        h1, h2 { margin-bottom: 16px; }
        a { color: #2563eb; text-decoration: none; }
        a:hover { text-decoration: underline; }
        .nav { display: flex; align-items: center; justify-content: space-between; margin-bottom: 20px; padding: 12px 16px; background: #fff; border-radius: 8px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); }
        .nav a { font-size: 14px; padding: 6px 12px; border-radius: 4px; }
        .nav a:hover { background: #e5e7eb; text-decoration: none; }
        .nav .title { font-size: 20px; font-weight: 700; color: #333; }
        .grid { display: grid; grid-template-columns: repeat(7, 1fr); background: #fff; border-radius: 8px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); overflow: hidden; }
        .grid .day-header { padding: 10px 4px; text-align: center; font-weight: 600; font-size: 13px; color: #6b7280; background: #f9fafb; border-bottom: 1px solid #e5e7eb; }
        .grid .day { min-height: 90px; padding: 6px; border: 1px solid #e5e7eb; position: relative; }
        .grid .day .day-num { font-size: 13px; font-weight: 500; color: #374151; margin-bottom: 4px; }
        .grid .day.other-month { background: #f9fafb; }
        .grid .day.other-month .day-num { color: #9ca3af; }
        .grid .day.today { background: #eff6ff; }
        .grid .day.today .day-num { color: #2563eb; font-weight: 700; }
        .event-pill { display: block; font-size: 11px; padding: 2px 6px; margin-bottom: 2px; border-radius: 3px; background: #dbeafe; color: #1e40af; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .event-pill:hover { background: #bfdbfe; text-decoration: none; }
        .card { background: #fff; border-radius: 8px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); padding: 24px; margin-bottom: 20px; }
        .card h2 { margin-bottom: 12px; }
        .field { margin-bottom: 16px; }
        .field label { display: block; font-weight: 600; font-size: 14px; margin-bottom: 4px; color: #374151; }
        .field input, .field textarea { width: 100%; padding: 8px 12px; border: 1px solid #d1d5db; border-radius: 6px; font-size: 14px; }
        .field textarea { min-height: 80px; resize: vertical; }
        .actions { display: flex; gap: 8px; margin-top: 20px; }
        .btn { display: inline-block; padding: 8px 16px; border-radius: 6px; font-size: 14px; font-weight: 500; border: none; cursor: pointer; text-align: center; }
        .btn-primary { background: #2563eb; color: #fff; }
        .btn-primary:hover { background: #1d4ed8; text-decoration: none; }
        .btn-danger { background: #dc2626; color: #fff; }
        .btn-danger:hover { background: #b91c1c; text-decoration: none; }
        .btn-secondary { background: #e5e7eb; color: #374151; }
        .btn-secondary:hover { background: #d1d5db; text-decoration: none; }
        .detail-row { margin-bottom: 12px; }
        .detail-row .label { font-weight: 600; font-size: 13px; color: #6b7280; text-transform: uppercase; margin-bottom: 2px; }
        .detail-row .value { font-size: 15px; }
        .view-toggle { display: flex; gap: 4px; padding: 4px; background: #f3f4f6; border-radius: 8px; margin-bottom: 20px; }
        .view-toggle a { flex: 1; text-align: center; padding: 8px 12px; border-radius: 6px; font-size: 13px; font-weight: 500; color: #6b7280; }
        .view-toggle a:hover { background: #e5e7eb; text-decoration: none; color: #374151; }
        .view-toggle a.active { background: #fff; color: #2563eb; box-shadow: 0 1px 2px rgba(0,0,0,0.1); font-weight: 600; }
        .schedule-group { margin-bottom: 24px; }
        .schedule-group-header { font-size: 14px; font-weight: 600; color: #6b7280; text-transform: uppercase; letter-spacing: 0.05em; padding: 8px 0; border-bottom: 1px solid #e5e7eb; margin-bottom: 8px; }
        .schedule-item { display: flex; gap: 16px; padding: 12px 16px; background: #fff; border-radius: 8px; box-shadow: 0 1px 2px rgba(0,0,0,0.06); margin-bottom: 8px; align-items: flex-start; transition: box-shadow 0.15s; }
        .schedule-item:hover { box-shadow: 0 2px 6px rgba(0,0,0,0.1); }
        .schedule-time { flex-shrink: 0; width: 100px; font-size: 13px; font-weight: 500; color: #6b7280; padding-top: 2px; }
        .schedule-details { flex: 1; }
        .schedule-details .ev-title { font-size: 15px; font-weight: 600; color: #1e40af; }
        .schedule-details .ev-title:hover { text-decoration: underline; }
        .schedule-details .ev-meta { font-size: 12px; color: #9ca3af; margin-top: 2px; }
        .empty-state { text-align: center; padding: 40px 20px; color: #9ca3af; font-size: 15px; }
        .day-grid { background: #fff; border-radius: 8px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); overflow: hidden; }
        .hour-row { display: flex; border-bottom: 1px solid #e5e7eb; min-height: 64px; }
        .hour-row:last-child { border-bottom: none; }
        .hour-label { flex-shrink: 0; width: 36px; padding: 2px 4px 2px 2px; font-size: 11px; font-weight: 500; color: #9ca3af; text-align: right; border-right: 1px solid #e5e7eb; }
        .hour-content { flex: 3; display: flex; flex-direction: column; }
        .hour-half { flex: 1; padding: 1px 4px; min-height: 32px; display: flex; flex-wrap: wrap; align-items: flex-start; gap: 2px; border-bottom: 1px dashed #f3f4f6; }
        .hour-half:last-child { border-bottom: none; }
        .hour-event { display: inline-block; font-size: 10px; padding: 2px 4px; border-radius: 3px; background: #dbeafe; color: #1e40af; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; font-weight: 500; max-width: 50%; }
        .hour-event:hover { background: #bfdbfe; text-decoration: none; }
        .hour-event .he-time { font-weight: 400; color: #3b82f6; font-size: 9px; }
        .hour-now { background: #fffbeb; }
        .quick-add { display: flex; flex: 1; min-width: 0; }
        .quick-add input { flex: 1; border: none; outline: none; background: transparent; font-size: 11px; color: #374151; padding: 1px 4px; min-width: 0; }
        .quick-add input::placeholder { color: #d1d5db; }
        .quick-add input:focus { background: #f0f9ff; border-radius: 3px; }
        .quick-add button { display: none; }
        .scroll-btn { display: flex; align-items: center; justify-content: center; padding: 6px; background: #f9fafb; border-bottom: 1px solid #e5e7eb; cursor: pointer; user-select: none; color: #9ca3af; font-size: 16px; font-weight: 700; }
        .scroll-btn:last-child { border-bottom: none; border-top: 1px solid #e5e7eb; }
        .scroll-btn:hover { background: #e5e7eb; color: #374151; }
        .week-grid { background: #fff; border-radius: 8px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); overflow: hidden; }
        .week-header { display: flex; border-bottom: 2px solid #e5e7eb; background: #fff; }
        .week-lbl-spc { flex-shrink: 0; width: 36px; border-right: 1px solid #e5e7eb; }
        .week-day-hdr { flex: 1; text-align: center; padding: 6px 2px; font-size: 11px; font-weight: 600; color: #6b7280; border-right: 1px solid #e5e7eb; }
        .week-day-hdr:last-child { border-right: none; }
        .week-day-hdr.today { color: #2563eb; background: #eff6ff; }
        .week-row { display: flex; border-bottom: 1px solid #e5e7eb; min-height: 48px; }
        .week-row:last-child { border-bottom: none; }
        .week-row.now-row { background: #fffbeb; }
        .week-lbl { flex-shrink: 0; width: 36px; padding: 3px 4px 0 2px; font-size: 10px; color: #9ca3af; text-align: right; border-right: 1px solid #e5e7eb; }
        .week-cell { flex: 1; border-right: 1px solid #e5e7eb; padding: 1px 2px; display: flex; flex-direction: column; gap: 1px; min-height: 48px; }
        .week-cell:last-child { border-right: none; }
        .week-cell.today { background: #eff6ff; }
        .week-event { display: block; font-size: 10px; padding: 1px 3px; border-radius: 2px; background: #dbeafe; color: #1e40af; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; font-weight: 500; }
        .week-event:hover { background: #bfdbfe; text-decoration: none; }
        '''
      ==
      ;script
        ;+  ;/  %-  trip
        '''
        document.addEventListener('DOMContentLoaded', function() {
          var sc = document.getElementById('day-scroll');
          var up = document.getElementById('scroll-up');
          var dn = document.getElementById('scroll-down');
          if (!sc || !up || !dn) return;
          var tid = null;
          var speed = 3;
          function startScroll(dir) {
            stopScroll();
            tid = setInterval(function() { sc.scrollTop += dir * speed; }, 16);
          }
          function stopScroll() { if (tid) { clearInterval(tid); tid = null; } }
          up.addEventListener('mousedown', function(e) { e.preventDefault(); startScroll(-1); });
          dn.addEventListener('mousedown', function(e) { e.preventDefault(); startScroll(1); });
          up.addEventListener('mouseup', stopScroll);
          dn.addEventListener('mouseup', stopScroll);
          up.addEventListener('mouseleave', stopScroll);
          dn.addEventListener('mouseleave', stopScroll);
          up.addEventListener('touchstart', function(e) { e.preventDefault(); startScroll(-1); });
          dn.addEventListener('touchstart', function(e) { e.preventDefault(); startScroll(1); });
          up.addEventListener('touchend', stopScroll);
          dn.addEventListener('touchend', stopScroll);
          var cur = document.querySelector('.hour-now');
          if (cur) { sc.scrollTop = cur.offsetTop - sc.offsetTop; }
        });
        '''
      ==
    ==
    ;body
      ;+  content
    ==
  ==
::  +view-toggle: render the view toggle bar
::
++  view-toggle
  |=  [active=tape base-url=tape y=@ud m=@ud d=@ud]
  ^-  manx
  =/  day-cls=tape    ?:(=(active "day") "active" "")
  =/  week-cls=tape   ?:(=(active "week") "active" "")
  =/  month-cls=tape  ?:(=(active "month") "active" "")
  =/  year-cls=tape   ?:(=(active "year") "active" "")
  =/  day-url=tape    "{base-url}/schedule/day?date={(ud-to-tape y)}-{(z-pad m)}-{(z-pad d)}"
  =/  week-url=tape   "{base-url}/schedule/week?date={(ud-to-tape y)}-{(z-pad m)}-{(z-pad d)}"
  =/  mon-url=tape    "{base-url}?m={(ud-to-tape m)}&y={(ud-to-tape y)}"
  =/  yr-url=tape     "{base-url}/schedule/year?y={(ud-to-tape y)}"
  ;div.view-toggle
    ;a(href day-url, class day-cls): Day
    ;a(href week-url, class week-cls): Week
    ;a(href mon-url, class month-cls): Month
    ;a(href yr-url, class year-cls): Year
  ==
::  +format-time: format @da as "HH:MM" tape
::
++  format-time
  |=  d=@da
  ^-  tape
  =/  dt  (yore d)
  "{(z-pad h.t.dt)}:{(z-pad m.t.dt)}"
::  +format-date-short: format @da as "Mon DD" tape
::
++  format-date-short
  |=  d=@da
  ^-  tape
  =/  dt  (yore d)
  "{(trip (month-name-short:calendar-date m.dt))} {(ud-to-tape d.t.dt)}"
::  +render-schedule-item: render a single event in schedule/agenda style
::
++  render-schedule-item
  |=  [=event base-url=tape]
  ^-  manx
  =/  time-str  (format-time start.event)
  =/  end-str  (format-time end.event)
  =/  loc-str=tape
    ?~  location.event  ""
    " - {(trip u.location.event)}"
  ;div.schedule-item
    ;div.schedule-time: {time-str} - {end-str}
    ;div.schedule-details
      ;a.ev-title(href "{base-url}/event/{(ud-to-tape id.event)}"): {(trip title.event)}
      ;+  ?~  description.event
            ?:  =(loc-str "")
              ;span;
            ;div.ev-meta: {loc-str}
          ?:  =(loc-str "")
            ;div.ev-meta: {(trip u.description.event)}
          ;div.ev-meta: {(trip u.description.event)}{loc-str}
    ==
  ==
::  +render-day-schedule: agenda view for a single day
::
++  render-day-schedule
  |=  [y=@ud m=@ud d=@ud from-param=@ud events=(map @ud event) base-url=tape now=@da]
  ^-  manx
  =/  day-da  (year [[& y] m d 0 0 0 ~])
  =/  day-end  (year [[& y] m d 23 59 59 ~])
  =/  day-events=(list event)
    %+  sort
      %+  skim  (turn ~(tap by events) |=([=@ud =event] event))
      |=(=event &((lth start.event day-end) (gth end.event day-da)))
    |=([a=event b=event] (lth start.a start.b))
  ::  prev/next day
  =/  prev-da  (sub day-da ~d1)
  =/  prev-dt  (yore prev-da)
  =/  next-da  (add day-da ~d1)
  =/  next-dt  (yore next-da)
  =/  dow  (day-of-week:calendar-date day-da)
  =/  wday  (trip (weekday-name:calendar-date dow))
  =/  mname  (trip (month-name:calendar-date m))
  =/  prev-url  "{base-url}/schedule/day?date={(ud-to-tape y.prev-dt)}-{(z-pad m.prev-dt)}-{(z-pad d.t.prev-dt)}"
  =/  next-url  "{base-url}/schedule/day?date={(ud-to-tape y.next-dt)}-{(z-pad m.next-dt)}-{(z-pad d.t.next-dt)}"
  ::  get current hour for highlighting and default start
  =/  now-dt  (yore now)
  =/  is-today=?  &(=(y y.now-dt) =(m m.now-dt) =(d d.t.now-dt))
  =/  now-hour=@ud  ?.(is-today 99 h.t.now-dt)
  =/  date-str=tape  "{(ud-to-tape y)}-{(z-pad m)}-{(z-pad d)}"
  ::  build 6 hour rows
  =/  hour=@ud  0
  =/  rows=(list manx)  ~
  |-
  ?:  =(hour 24)
    %+  page-wrapper  "{wday}, {mname} {(ud-to-tape d)}, {(ud-to-tape y)}"
    ;div
      ;+  (view-toggle "day" base-url y m d)
      ;div.nav
        ;a(href prev-url): < Prev
        ;span.title: {wday}, {mname} {(ud-to-tape d)}, {(ud-to-tape y)}
        ;a(href next-url): Next >
      ==
      ;div.day-grid
        ;div.scroll-btn(id "scroll-up"): ▲
        ;div.day-scroll(id "day-scroll")
          ;*  (flop rows)
        ==
        ;div.scroll-btn(id "scroll-down"): ▼
      ==
    ==
  ::  format hour label
  =/  ampm=tape
    ?:  =(hour 0)   "12 AM"
    ?:  (lth hour 12)  "{(ud-to-tape hour)} AM"
    ?:  =(hour 12)  "12 PM"
    "{(ud-to-tape (sub hour 12))} PM"
  ::  find events in first half (:00-:29)
  =/  h1-start  (year [[& y] m d hour 0 0 ~])
  =/  h1-end    (year [[& y] m d hour 29 59 ~])
  =/  h1-events=(list event)
    %+  skim  day-events
    |=(=event &((lth start.event h1-end) (gth end.event h1-start)))
  ::  find events in second half (:30-:59)
  =/  h2-start  (year [[& y] m d hour 30 0 ~])
  =/  h2-end    (year [[& y] m d hour 59 59 ~])
  =/  h2-events=(list event)
    %+  skim  day-events
    |=(=event &((lth start.event h2-end) (gth end.event h2-start)))
  ::  build pills for each half
  =/  h1-pills=(list manx)
    %+  turn  h1-events
    |=  =event
    ;a.hour-event(href "{base-url}/event/{(ud-to-tape id.event)}"): {(trip title.event)}
  =/  h2-pills=(list manx)
    %+  turn  h2-events
    |=  =event
    ;a.hour-event(href "{base-url}/event/{(ud-to-tape id.event)}"): {(trip title.event)}
  ::  row class: highlight current hour
  =/  row-cls=tape  ?:(=(hour now-hour) "hour-row hour-now" "hour-row")
  ::  quick-add form times: top half = :00-:30, bottom half = :30-:00
  =/  next-hour=@ud  ?:((lth hour 23) +(hour) 23)
  =/  ret-from=tape  "0"
  =/  row=manx
    ;div(class row-cls)
      ;div.hour-label: {ampm}
      ;div.hour-content
        ;div.hour-half
          ;*  h1-pills
          ;form.quick-add(method "POST", action "{base-url}/add-day")
            ;input(type "hidden", name "start-date", value date-str);
            ;input(type "hidden", name "start-time", value "{(z-pad hour)}:00");
            ;input(type "hidden", name "end-date", value date-str);
            ;input(type "hidden", name "end-time", value "{(z-pad hour)}:30");
            ;input(type "hidden", name "return-date", value date-str);
            ;input(type "hidden", name "return-from", value ret-from);
            ;input(type "text", name "title", placeholder "+", autocomplete "off");
            ;button(type "submit"): +
          ==
        ==
        ;div.hour-half
          ;*  h2-pills
          ;form.quick-add(method "POST", action "{base-url}/add-day")
            ;input(type "hidden", name "start-date", value date-str);
            ;input(type "hidden", name "start-time", value "{(z-pad hour)}:30");
            ;input(type "hidden", name "end-date", value date-str);
            ;input(type "hidden", name "end-time", value "{(z-pad next-hour)}:00");
            ;input(type "hidden", name "return-date", value date-str);
            ;input(type "hidden", name "return-from", value ret-from);
            ;input(type "text", name "title", placeholder "+", autocomplete "off");
            ;button(type "submit"): +
          ==
        ==
      ==
    ==
  $(hour +(hour), rows [row rows])
::  +render-week-schedule: 7-column time-grid week view (Sun–Sat)
::
++  render-week-schedule
  |=  [anchor=@da events=(map @ud event) base-url=tape now=@da]
  ^-  manx
  =/  ws       (week-start-da:calendar-date anchor)
  =/  we       (week-end-da:calendar-date anchor)
  =/  prev-ws  (sub ws (mul 7 ~d1))
  =/  next-ws  (add ws (mul 7 ~d1))
  =/  prev-dt  (yore prev-ws)
  =/  next-dt  (yore next-ws)
  =/  prev-url  "{base-url}/schedule/week?date={(ud-to-tape y.prev-dt)}-{(z-pad m.prev-dt)}-{(z-pad d.t.prev-dt)}"
  =/  next-url  "{base-url}/schedule/week?date={(ud-to-tape y.next-dt)}-{(z-pad m.next-dt)}-{(z-pad d.t.next-dt)}"
  ::  all events overlapping this week
  =/  week-events=(list event)
    %+  skim  (turn ~(tap by events) |=([=@ud =event] event))
    |=(=event &((lth start.event we) (gth end.event ws)))
  ::  pre-compute per-day [day-da sorted-events] for each of 7 days
  =/  day-pairs=(list [@da (list event)])
    =|  i=@ud
    |-  ^-  (list [@da (list event)])
    ?:  =(i 7)  ~
    =/  day-da   (add ws (mul i ~d1))
    =/  day-end  (add day-da ~d1)
    =/  devs=(list event)
      %+  sort
        %+  skim  week-events
        |=(=event &((lth start.event day-end) (gth end.event day-da)))
      |=([a=event b=event] (lth start.a start.b))
    [[day-da devs] $(i +(i))]
  ::  build title
  =/  ws-dt     (yore ws)
  =/  sat-da    (sub we ~d1)
  =/  sat-dt    (yore sat-da)
  =/  sun-mname  (trip (month-name:calendar-date m.ws-dt))
  =/  sat-mname  (trip (month-name:calendar-date m.sat-dt))
  =/  title-tape=tape
    ?:  =(m.ws-dt m.sat-dt)
      "{sun-mname} {(ud-to-tape d.t.ws-dt)}–{(ud-to-tape d.t.sat-dt)}, {(ud-to-tape y.ws-dt)}"
    "{sun-mname} {(ud-to-tape d.t.ws-dt)} – {sat-mname} {(ud-to-tape d.t.sat-dt)}, {(ud-to-tape y.sat-dt)}"
  ::  today and current hour
  =/  now-dt    (yore now)
  =/  now-hour  h.t.now-dt
  ::  column headers (Sun Mon … Sat with date number)
  =/  day-hdrs=(list manx)
    %+  turn  day-pairs
    |=  [day-da=@da devs=(list event)]
    =/  dt       (yore day-da)
    =/  dow      (day-of-week:calendar-date day-da)
    =/  wname    (trip (weekday-name-short:calendar-date dow))
    =/  is-today=?  &(=(y.dt y.now-dt) =(m.dt m.now-dt) =(d.t.dt d.t.now-dt))
    =/  cls=tape  ?:(is-today "week-day-hdr today" "week-day-hdr")
    ;div(class cls): {wname} {(ud-to-tape d.t.dt)}
  ::  week start as date string for redirect-back in quick-add
  =/  ws-date-str=tape  "{(ud-to-tape y.ws-dt)}-{(z-pad m.ws-dt)}-{(z-pad d.t.ws-dt)}"
  ::  build 24 hour rows
  =/  hour=@ud  0
  =/  rows=(list manx)  ~
  |-
  ?:  =(hour 24)
    %+  page-wrapper  "Week: {title-tape}"
    ;div
      ;+  (view-toggle "week" base-url y.ws-dt m.ws-dt d.t.ws-dt)
      ;div.nav
        ;a(href prev-url): < Prev Week
        ;span.title: {title-tape}
        ;a(href next-url): Next Week >
      ==
      ;div.week-grid
        ;div.scroll-btn(id "scroll-up"): ▲
        ;div.day-scroll(id "day-scroll")
          ;div.week-header
            ;div.week-lbl-spc;
            ;*  day-hdrs
          ==
          ;*  (flop rows)
        ==
        ;div.scroll-btn(id "scroll-down"): ▼
      ==
    ==
  ::  am/pm label
  =/  ampm=tape
    ?:  =(hour 0)      "12a"
    ?:  (lth hour 12)  "{(ud-to-tape hour)}a"
    ?:  =(hour 12)     "12p"
    "{(ud-to-tape (sub hour 12))}p"
  =/  row-cls=tape  ?:(=(hour now-hour) "week-row now-row" "week-row")
  ::  7 cells for this hour, one per day
  =/  cells=(list manx)
    %+  turn  day-pairs
    |=  [day-da=@da devs=(list event)]
    =/  dt      (yore day-da)
    =/  h-start  (year [[& y.dt] m.dt d.t.dt hour 0 0 ~])
    =/  h-end    (year [[& y.dt] m.dt d.t.dt hour 59 59 ~])
    =/  is-today=?  &(=(y.dt y.now-dt) =(m.dt m.now-dt) =(d.t.dt d.t.now-dt))
    =/  h-events=(list event)
      %+  skim  devs
      |=(=event &((lth start.event h-end) (gth end.event h-start)))
    =/  date-str=tape  "{(ud-to-tape y.dt)}-{(z-pad m.dt)}-{(z-pad d.t.dt)}"
    =/  next-hour=@ud  ?:((lth hour 23) +(hour) 23)
    =/  end-time=tape  ?:((lth hour 23) "{(z-pad next-hour)}:00" "23:59")
    =/  pills=(list manx)
      %+  turn  h-events
      |=  =event
      ;a.week-event(href "{base-url}/edit/{(ud-to-tape id.event)}"): {(trip title.event)}
    =/  cls=tape  ?:(is-today "week-cell today" "week-cell")
    ;div(class cls)
      ;*  pills
      ;form.quick-add(method "POST", action "{base-url}/add-week")
        ;input(type "hidden", name "start-date", value date-str);
        ;input(type "hidden", name "start-time", value "{(z-pad hour)}:00");
        ;input(type "hidden", name "end-date", value date-str);
        ;input(type "hidden", name "end-time", value end-time);
        ;input(type "hidden", name "return-date", value ws-date-str);
        ;input(type "text", name "title", placeholder "+", autocomplete "off");
        ;button(type "submit"): +
      ==
    ==
  =/  row=manx
    ;div(class row-cls)
      ;div.week-lbl: {ampm}
      ;*  cells
    ==
  $(hour +(hour), rows [row rows])
::  +render-month-schedule: agenda view for a month grouped by day
::
++  render-month-schedule
  |=  [y=@ud m=@ud events=(map @ud event) base-url=tape now=@da]
  ^-  manx
  =/  mname  (trip (month-name:calendar-date m))
  =/  dim  (days-in-month:calendar-date y m)
  =/  range-start  (month-start-da:calendar-date y m)
  =/  range-end  (month-end-da:calendar-date y m)
  =/  month-events=(list event)
    %+  sort
      %+  skim  (turn ~(tap by events) |=([=@ud =event] event))
      |=(=event &((lth start.event range-end) (gth end.event range-start)))
    |=([a=event b=event] (lth start.a start.b))
  ::  prev/next month
  =/  [py=@ud pm=@ud]  (prev-month:calendar-date y m)
  =/  [ny=@ud nm=@ud]  (next-month:calendar-date y m)
  =/  prev-url  "{base-url}/schedule/month?m={(ud-to-tape pm)}&y={(ud-to-tape py)}"
  =/  next-url  "{base-url}/schedule/month?m={(ud-to-tape nm)}&y={(ud-to-tape ny)}"
  =/  cur  (yore now)
  %+  page-wrapper  "Schedule - {mname} {(ud-to-tape y)}"
  ;div
    ;+  (view-toggle "month" base-url y m d.t.cur)
    ;div.nav
      ;a(href prev-url): < Prev Month
      ;span.title: {mname} {(ud-to-tape y)}
      ;a(href next-url): Next Month >
    ==
    ;+  ?:  =(~ month-events)
          ;div.card
            ;div.empty-state: No events scheduled this month
          ==
        ::  group events by day
        =/  day-idx=@ud  1
        =/  groups=(list manx)  ~
        |-
        ?:  (gth day-idx dim)
          ;div
            ;*  (flop groups)
          ==
        =/  day-da  (year [[& y] m day-idx 0 0 0 ~])
        =/  day-end  (year [[& y] m day-idx 23 59 59 ~])
        =/  day-evs=(list event)
          %+  skim  month-events
          |=(=event &((lth start.event day-end) (gth end.event day-da)))
        ?:  =(~ day-evs)
          $(day-idx +(day-idx))
        =/  dow  (day-of-week:calendar-date day-da)
        =/  wday  (trip (weekday-name:calendar-date dow))
        =/  group=manx
          ;div.schedule-group
            ;div.schedule-group-header: {wday}, {mname} {(ud-to-tape day-idx)}
            ;*  %+  turn  day-evs
                |=(=event (render-schedule-item event base-url))
          ==
        $(day-idx +(day-idx), groups [group groups])
  ==
::  +render-year-schedule: agenda view for a year grouped by month
::
++  render-year-schedule
  |=  [y=@ud events=(map @ud event) base-url=tape now=@da]
  ^-  manx
  =/  range-start  (year-start-da:calendar-date y)
  =/  range-end  (year-end-da:calendar-date y)
  =/  year-events=(list event)
    %+  sort
      %+  skim  (turn ~(tap by events) |=([=@ud =event] event))
      |=(=event &((lth start.event range-end) (gth end.event range-start)))
    |=([a=event b=event] (lth start.a start.b))
  =/  prev-url  "{base-url}/schedule/year?y={(ud-to-tape (dec y))}"
  =/  next-url  "{base-url}/schedule/year?y={(ud-to-tape +(y))}"
  =/  cur  (yore now)
  %+  page-wrapper  "Schedule - {(ud-to-tape y)}"
  ;div
    ;+  (view-toggle "year" base-url y m.cur d.t.cur)
    ;div.nav
      ;a(href prev-url): < Prev Year
      ;span.title: {(ud-to-tape y)}
      ;a(href next-url): Next Year >
    ==
    ;+  ?:  =(~ year-events)
          ;div.card
            ;div.empty-state: No events scheduled this year
          ==
        ::  group events by month
        =/  mon-idx=@ud  1
        =/  groups=(list manx)  ~
        |-
        ?:  (gth mon-idx 12)
          ;div
            ;*  (flop groups)
          ==
        =/  mon-start  (month-start-da:calendar-date y mon-idx)
        =/  mon-end  (month-end-da:calendar-date y mon-idx)
        =/  mon-evs=(list event)
          %+  skim  year-events
          |=(=event &((lth start.event mon-end) (gth end.event mon-start)))
        ?:  =(~ mon-evs)
          $(mon-idx +(mon-idx))
        =/  mname  (trip (month-name:calendar-date mon-idx))
        =/  group=manx
          ;div.schedule-group
            ;div.schedule-group-header: {mname}
            ;*  %+  turn  mon-evs
                |=(=event (render-schedule-item event base-url))
          ==
        $(mon-idx +(mon-idx), groups [group groups])
  ==
::  +render-month-view: render calendar month grid
::
++  render-month-view
  |=  [y=@ud m=@ud events=(map @ud event) base-url=tape now=@da]
  ^-  manx
  =/  mname  (trip (month-name:calendar-date m))
  =/  dim  (days-in-month:calendar-date y m)
  =/  dow1  (day-of-week:calendar-date (month-start-da:calendar-date y m))
  =/  [py=@ud pm=@ud]  (prev-month:calendar-date y m)
  =/  [ny=@ud nm=@ud]  (next-month:calendar-date y m)
  =/  prev-dim  (days-in-month:calendar-date py pm)
  ::  get events in this month
  =/  range-start  (month-start-da:calendar-date y m)
  =/  range-end  (month-end-da:calendar-date y m)
  =/  month-events=(list event)
    %+  skim  (turn ~(tap by events) |=([=@ud =event] event))
    |=(=event &((lth start.event range-end) (gth end.event range-start)))
  ::  get today info
  =/  today-date  (yore now)
  =/  today-y  y.today-date
  =/  today-m  m.today-date
  =/  today-d  d.t.today-date
  ::  build day cells
  =/  total-cells=@ud  42
  =/  cells=(list manx)  ~
  =/  idx=@ud  0
  |-
  ?:  =(idx total-cells)
    ::  render full page
    =/  prev-url  "{base-url}?m={(ud-to-tape pm)}&y={(ud-to-tape py)}"
    =/  next-url  "{base-url}?m={(ud-to-tape nm)}&y={(ud-to-tape ny)}"
    %+  page-wrapper  "Calendar - {mname} {(ud-to-tape y)}"
    ;div
      ;+  (view-toggle "month" base-url y m today-d)
      ;div.nav
        ;a(href prev-url): < Prev
        ;span.title: {mname} {(ud-to-tape y)}
        ;a(href next-url): Next >
      ==
      ;div.nav
        ;span;
        ;a.btn.btn-primary(href "{base-url}/add?m={(ud-to-tape m)}&y={(ud-to-tape y)}"): + Add Event
      ==
      ;div.grid
        ;div.day-header: Sun
        ;div.day-header: Mon
        ;div.day-header: Tue
        ;div.day-header: Wed
        ;div.day-header: Thu
        ;div.day-header: Fri
        ;div.day-header: Sat
        ;*  (flop cells)
      ==
    ==
  ::  determine which day this cell represents
  =/  cell-day=@ud
    ?:  (lth idx dow1)
      ::  previous month trailing days
      (add (sub prev-dim (sub dow1 idx)) 1)
    =/  d  (add (sub idx dow1) 1)
    ?:  (gth d dim)
      ::  next month leading days
      (sub d dim)
    d
  =/  in-month=?  &((gte idx dow1) (lte (add (sub idx dow1) 1) dim))
  =/  is-today=?  &(in-month =(y today-y) =(m today-m) =(cell-day today-d))
  ::  find events on this day
  =/  day-events=(list event)
    ?.  in-month  ~
    =/  day-da  (year [[& y] m cell-day 0 0 0 ~])
    =/  day-end  (year [[& y] m cell-day 23 59 59 ~])
    %+  skim  month-events
    |=(=event &((lth start.event day-end) (gth end.event day-da)))
  ::  build event pills
  =/  pills=(list manx)
    %+  turn  day-events
    |=  =event
    ;a.event-pill(href "{base-url}/event/{(ud-to-tape id.event)}"): {(trip title.event)}
  ::  build cell class
  =/  cls=tape
    %+  weld  "day"
    %+  weld  ?.(in-month " other-month" "")
    ?.(is-today "" " today")
  ::  build cell
  =/  cell=manx
    ;div(class cls)
      ;div.day-num: {(ud-to-tape cell-day)}
      ;*  pills
    ==
  $(idx +(idx), cells [cell cells])
::  +render-event-detail: render single event view
::
++  render-event-detail
  |=  [=event base-url=tape]
  ^-  manx
  =/  s-date  (yore start.event)
  =/  e-date  (yore end.event)
  =/  start-str  "{(ud-to-tape y.s-date)}-{(z-pad m.s-date)}-{(z-pad d.t.s-date)} {(z-pad h.t.s-date)}:{(z-pad m.t.s-date)}"
  =/  end-str  "{(ud-to-tape y.e-date)}-{(z-pad m.e-date)}-{(z-pad d.t.e-date)} {(z-pad h.t.e-date)}:{(z-pad m.t.e-date)}"
  %+  page-wrapper  "Event: {(trip title.event)}"
  ;div
    ;div.nav
      ;a(href base-url): < Back to Calendar
      ;span.title: Event Details
      ;span;
    ==
    ;div.card
      ;h2: {(trip title.event)}
      ;div.detail-row
        ;div.label: Start
        ;div.value: {start-str}
      ==
      ;div.detail-row
        ;div.label: End
        ;div.value: {end-str}
      ==
      ;+  ?~  description.event
            ;span;
          ;div.detail-row
            ;div.label: Description
            ;div.value: {(trip u.description.event)}
          ==
      ;+  ?~  location.event
            ;span;
          ;div.detail-row
            ;div.label: Location
            ;div.value: {(trip u.location.event)}
          ==
      ;div.actions
        ;a.btn.btn-primary(href "{base-url}/edit/{(ud-to-tape id.event)}"): Edit
        ;form(method "POST", action "{base-url}/delete/{(ud-to-tape id.event)}", style "display:inline")
          ;button.btn.btn-danger(type "submit"): Delete
        ==
      ==
    ==
  ==
::  +render-add-form: render add event form
::
++  render-add-form
  |=  [pre-y=@ud pre-m=@ud base-url=tape]
  ^-  manx
  =/  date-default  "{(ud-to-tape pre-y)}-{(z-pad pre-m)}-01"
  %+  page-wrapper  "Add Event"
  ;div
    ;div.nav
      ;a(href "{base-url}?m={(ud-to-tape pre-m)}&y={(ud-to-tape pre-y)}"): < Back to Calendar
      ;span.title: Add Event
      ;span;
    ==
    ;div.card
      ;form(method "POST", action "{base-url}/add")
        ;div.field
          ;label: Title
          ;input(type "text", name "title", required "required", placeholder "Event title");
        ==
        ;div.field
          ;label: Start Date
          ;input(type "date", name "start-date", required "required", value date-default);
        ==
        ;div.field
          ;label: Start Time
          ;input(type "time", name "start-time", value "09:00");
        ==
        ;div.field
          ;label: End Date
          ;input(type "date", name "end-date", required "required", value date-default);
        ==
        ;div.field
          ;label: End Time
          ;input(type "time", name "end-time", value "10:00");
        ==
        ;div.field
          ;label: Description
          ;textarea(name "description", placeholder "Optional description")
            ;+  ;/  ""
          ==
        ==
        ;div.field
          ;label: Location
          ;input(type "text", name "location", placeholder "Optional location");
        ==
        ;div.actions
          ;button.btn.btn-primary(type "submit"): Add Event
          ;a.btn.btn-secondary(href "{base-url}?m={(ud-to-tape pre-m)}&y={(ud-to-tape pre-y)}"): Cancel
        ==
      ==
    ==
  ==
::  +render-edit-form: render edit event form (pre-filled)
::
++  render-edit-form
  |=  [=event base-url=tape]
  ^-  manx
  =/  s-date  (yore start.event)
  =/  e-date  (yore end.event)
  =/  start-date-val  "{(ud-to-tape y.s-date)}-{(z-pad m.s-date)}-{(z-pad d.t.s-date)}"
  =/  start-time-val  "{(z-pad h.t.s-date)}:{(z-pad m.t.s-date)}"
  =/  end-date-val  "{(ud-to-tape y.e-date)}-{(z-pad m.e-date)}-{(z-pad d.t.e-date)}"
  =/  end-time-val  "{(z-pad h.t.e-date)}:{(z-pad m.t.e-date)}"
  %+  page-wrapper  "Edit: {(trip title.event)}"
  ;div
    ;div.nav
      ;a(href "{base-url}/event/{(ud-to-tape id.event)}"): < Back to Event
      ;span.title: Edit Event
      ;span;
    ==
    ;div.card
      ;form(method "POST", action "{base-url}/edit/{(ud-to-tape id.event)}")
        ;div.field
          ;label: Title
          ;input(type "text", name "title", required "required", value "{(trip title.event)}");
        ==
        ;div.field
          ;label: Start Date
          ;input(type "date", name "start-date", required "required", value start-date-val);
        ==
        ;div.field
          ;label: Start Time
          ;input(type "time", name "start-time", value start-time-val);
        ==
        ;div.field
          ;label: End Date
          ;input(type "date", name "end-date", required "required", value end-date-val);
        ==
        ;div.field
          ;label: End Time
          ;input(type "time", name "end-time", value end-time-val);
        ==
        ;div.field
          ;label: Description
          ;textarea(name "description")
            ;+  ;/  ?~(description.event "" (trip u.description.event))
          ==
        ==
        ;div.field
          ;label: Location
          ;input(type "text", name "location", value "{?~(location.event "" (trip u.location.event))}");
        ==
        ;div.actions
          ;button.btn.btn-primary(type "submit"): Save Changes
          ;a.btn.btn-secondary(href "{base-url}/event/{(ud-to-tape id.event)}"): Cancel
        ==
      ==
    ==
  ==
::  +ud-to-tape: render @ud as plain decimal tape (no dot separators)
::
++  ud-to-tape
  |=  n=@ud
  ^-  tape
  ?:  =(n 0)  "0"
  %-  flop
  |-  ^-  tape
  ?:  =(n 0)  ~
  =/  d  (mod n 10)
  [(add '0' d) $(n (div n 10))]
::  +z-pad: zero-pad a number to 2 digits
::
++  z-pad
  |=  n=@ud
  ^-  tape
  ?:  (lth n 10)
    "0{(ud-to-tape n)}"
  (ud-to-tape n)
--
