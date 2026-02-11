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
        '''
      ==
    ==
    ;body
      ;+  content
    ==
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
