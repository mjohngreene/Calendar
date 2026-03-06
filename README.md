# Calendar — Urbit App

A personal calendar app for Urbit. Manage events from a clean web UI served directly from your ship, with no external dependencies.

## Features

- **Month view** — classic calendar grid with event pills per day
- **Week view** — agenda view for the current week, Sun–Sat, with prev/next navigation
- **Day view** — hourly time grid with quick-add from any slot
- **Month & Year schedule** — agenda-style event lists grouped by day or month
- **Full CRUD** — add, edit, delete events with title, start/end time, description, and location
- **Landscape tile** — installs as a first-class app in Urbit's Landscape UI

## Structure

```
app/calendar.hoon       Gall agent — HTTP routing, state, pokes
sur/calendar.hoon       Types: event, action, update, state
lib/calendar.hoon       Pure logic: add/edit/delete/get/list events
lib/calendar-date.hoon  Date arithmetic: month bounds, week bounds, leap years, day-of-week
lib/calendar-ui.hoon    Sail HTML rendering for all views and forms
mar/calendar/           Marks for action and update
gen/calendar/           CLI generators: add, list, delete
build.sh                Assembles dist/ desk from app code + deps
```

## Installation

### Prerequisites

You need `deps/base-dev` and optionally `deps/landscape-dev` for the Landscape tile.
Copy these from a running Urbit base desk or pull from the Urbit repo.

### Build

```bash
./build.sh
```

This produces a complete Urbit desk at `dist/calendar/`.

### Install on a fakezod (dev)

```bash
# 1. Merge base into a new desk
|merge %calendar our %base

# 2. Copy built files into the mounted desk
cp -r dist/calendar/* /path/to/zod/calendar/

# 3. Commit and install
|commit %calendar
|install our %calendar
```

### Install on a live ship

Use `|install` from a desk source, or copy files manually and `|commit`.

## Development

The app uses only Hoon stdlib + standard Gall/Eyre/server.hoon — no JS frameworks, no external build tools.

State is versioned (`versioned-cal-state`, currently `%0`). Migrations go in `on-load`.

### Running tests

```
+test-calendar
+test-calendar-date
```

## Roadmap

- [ ] Recurring events
- [ ] iCal import / export
- [ ] Ship-to-ship event sharing via Ames
- [ ] Event reminders (behn timer pokes)

## License

MIT
