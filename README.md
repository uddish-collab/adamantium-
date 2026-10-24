# Adamantium

**A War Thunder Mobile gaming community hub built for a college software engineering project.**

- **Live website:** [uddish-collab.github.io/adamantium-](https://uddish-collab.github.io/adamantium-/)
- **GitHub repository:** [uddish-collab/adamantium-](https://github.com/uddish-collab/adamantium-)

Adamantium brings ground, aviation, and naval content together in one dark, military-inspired website. Visitors can browse vehicle catalogs and guides, explore showcases, and view room scoreboards. Signed-in players can use the community room features backed by Supabase.

> Adamantium is an independent fan project for educational use. It is not an official War Thunder or Gaijin Entertainment product and is not affiliated with or endorsed by Gaijin Entertainment.

---

## Contents

- [Project overview](#project-overview)
- [Features](#features)
- [Technology stack](#technology-stack)
- [Pages and project structure](#pages-and-project-structure)
- [Run the site locally](#run-the-site-locally)
- [Supabase and database](#supabase-and-database)
- [Database security](#database-security)
- [Demo data](#demo-data)
- [Assets](#assets)
- [Deployment](#deployment)
- [Troubleshooting](#troubleshooting)
- [Known project limitations](#known-project-limitations)
- [Acknowledgements](#acknowledgements)

---

## Project overview

Adamantium is a static, multi-page web application. The browser loads the site's HTML, CSS, JavaScript, and media files. Supabase provides the hosted authentication service and PostgreSQL database; page scripts call the Supabase JavaScript client from the browser.

The project has three mode pages:

| Mode | Page | Database catalog |
| --- | --- | --- |
| Ground forces | `tanks.html` | `vehicles` |
| Aviation | `aviation.html` | `aircraft` |
| Naval forces | `ships.html` | `naval_vessels` |
| Project and team | `team-akagami.html` | Team profiles and downloadable project report |

The site also includes the landing page (`index.html`) and sign-in page (`login.html`). The project is published as a static site using GitHub Pages.

## Features

### Public browsing

- A home page introducing the project and linking to each mode.
- Separate ground, aviation, and naval pages with image showcases and vehicle information.
- Searchable or filterable catalogs where implemented.
- Mode-specific guides stored in Supabase's shared `guides` table.
- Room scoreboards that display stored scores for a selected room.
- Local image and video assets organized under `assets/`.

### Accounts and rooms

- Supabase Auth sign-in and sign-out.
- Room creation for signed-in users.
- Room discovery and join-request submission.
- Request status display and owner responses where supported by the page.
- Room-owner controls for eligible rooms.
- Demo rooms and sample scoreboard rows for presentation.
- A Team Akagami page with member profiles and links, plus downloadable Word and PDF copies of the project report.

Room access and operations depend on the current Supabase table grants and Row Level Security policies. A button being hidden in the interface is not a substitute for a database policy.

## Technology stack

| Area | Technology |
| --- | --- |
| Front end | HTML5, CSS3, vanilla JavaScript |
| Authentication | Supabase Auth |
| Database | Supabase-hosted PostgreSQL |
| Browser database client | Supabase JavaScript client v2, loaded from a CDN |
| Development | Visual Studio Code and a local static web server (for example, VS Code Live Server) |
| Version control | Git and GitHub |

There is no separate custom server application or backend language in this version. Browser-side application logic is JavaScript; database structure and policies are defined with SQL.

## Pages and project structure

```text
adamantium/
├── index.html                         # Home / project landing page
├── login.html                         # Supabase sign-in flow
├── tanks.html                         # Ground catalog, guides, rooms, and scores
├── aviation.html                      # Aircraft catalog, guides, rooms, and scores
├── ships.html                         # Naval catalog, guides, rooms, and scores
├── team-akagami.html                  # Team profiles and project report downloads
├── style.css                          # Shared visual styling
├── script.js                          # Shared browser-side behavior
├── Adamantium_Software_Engineering_Project_Report_Draft.docx
├── Adamantium_Software_Engineering_Project_Report_Draft.pdf
├── supabase-schema.sql                # Schema reference/export
├── googleddc2968388aeebe7.html         # Search Console ownership verification
├── assets/
│   ├── gameplay.mp4                   # Home-page gameplay media
│   ├── tanks/                         # Ground showcase images
│   ├── aviation/                      # Aviation showcase images
│   ├── naval/                         # Naval showcase images
│   └── meme/                          # Home-page sign-off media
├── supabase/
│   ├── config.toml                    # Supabase CLI project configuration
│   └── queries/                       # Saved SQL scripts grouped by purpose
├── package.json                       # Supabase CLI development dependency
├── package-lock.json
└── README.md
```

The exact contents of `assets/` can change as media is updated. Keep file names and paths in the HTML in sync with the files in those folders. Spaces and capitalization in asset names can cause broken links on case-sensitive hosting.

## Run the site locally

1. Clone or download the repository.
2. Open the project folder in Visual Studio Code.
3. Start a static web server from the project root. With the Live Server extension, open `index.html` and choose **Open with Live Server**.
4. Use the local server URL it displays. Do not open the HTML pages as `file://` URLs when checking authentication or database requests.
5. Confirm that the browser has internet access so it can load the Supabase client and reach the hosted Supabase project.

The public site files are static. Installing the Supabase CLI is only needed for database administration tasks; it is not required just to open the front end.

## Supabase and database

The current application uses these public-schema tables:

| Group | Tables | Purpose |
| --- | --- | --- |
| Identity | `profiles` | Optional public profile information associated with an Auth user. |
| Guides | `guides` | Mode-specific guide content and author display names. |
| Ground catalog | `vehicles` | Tank and other ground-vehicle records. |
| Aviation catalog | `aircraft` | Aircraft records. |
| Naval catalog | `naval_vessels` | Ship and vessel records. |
| Ground rooms | `tank_rooms`, `tank_room_requests`, `tank_room_scores` | Ground room ownership, join requests, and scoreboard entries. |
| Aviation rooms | `aviation_rooms`, `aviation_room_requests`, `aviation_room_scores` | Aviation room ownership, join requests, and scoreboard entries. |
| Naval rooms | `naval_rooms`, `naval_room_requests`, `naval_room_scores` | Naval room ownership, join requests, and scoreboard entries. |

Supabase Auth identities are stored in `auth.users`, outside the public table list. Room owner, requester, and score relationships use the relevant foreign keys. Some demo scoreboard entries are display-only, so their `player_id` may be `NULL` while `player_name` is populated.

### Saved SQL files

The project keeps SQL scripts in `supabase/queries/`. The folder includes scripts for tank, aviation, naval, guide, demo, and security setup, along with database inventory and cleanup queries. Read a script and confirm its purpose before running it against a database. Cleanup and reset scripts can remove data or database objects.

**Important:** these saved queries are not the same thing as a verified, ordered Supabase migration history. The repository does not currently prove that a new Supabase project can be rebuilt from an empty database by applying migrations. Before rebuilding or changing the production database, export and verify the current schema and data, then establish and test an ordered migration workflow.

### Supabase client configuration

The pages initialize the Supabase JavaScript client using the project URL and a browser publishable key. These values are necessarily visible to site visitors. Keep Row Level Security enabled and configure policies carefully. Never place a Supabase **service-role** key, database password, or other privileged secret in HTML, JavaScript, GitHub, or any other public client-side file.

## Database security

Row Level Security (RLS) is enabled on the application tables. Policies and grants should enforce authorization in PostgreSQL, even if the front end also hides or disables controls. In general, policies should ensure that:

- public catalog and guide reads expose only intended content;
- a signed-in user can create a room only as its authenticated owner;
- users can submit requests as themselves and only for eligible rooms;
- only the relevant room owner can respond to a request;
- room changes and deletions are limited to the room owner;
- public scoreboard reads expose only the fields intended to be public; and
- demo-room restrictions are enforced in the database if they must be tamper-resistant.

After changing a policy, test it with an anonymous session, the room owner, the requester, and a different signed-in user. The exact allowed operations are determined by the live policies in Supabase, not by this README.

## Demo data

Demo rooms and their scoreboard rows are presentation data used to show how the room and scoreboard interfaces look with content. Demo score names are not necessarily linked to real accounts. Treat the SQL seeder as an optional, repeatable data setup script only after inspecting the target project and confirming the expected owner account.

Do not use demo rows to represent real match results. Do not run reset, delete, or cleanup scripts on production data unless you understand their effects and have a verified backup.

## Assets

The mode-page slideshows, gameplay video, and meme media are stored locally under `assets/`. The three Team Akagami profile photos are served from the public Supabase Storage bucket `team-photos`, so those images are not stored in the GitHub repository. Public bucket images can be viewed by anyone with their file URLs.

To replace a local slideshow image:

1. Put the new file in the correct mode folder.
2. Update the matching image path in that mode's HTML.
3. Preserve the correct extension and spelling, including spaces and capitalization.
4. Preview the page through the local web server and confirm each slideshow image loads.
5. Commit the new asset along with the HTML path change.

Only publish media that you have permission to use. Add attribution where its license requires it.

## Deployment

The site is published through GitHub Pages from the `main` branch and repository root. The live project URL is [https://uddish-collab.github.io/adamantium-/](https://uddish-collab.github.io/adamantium-/). The static host serves the front-end files; Supabase continues to provide authentication, PostgreSQL, and profile-photo storage.

To publish later changes:

1. Save the updated site files in the project folder.
2. Commit and push the intended changes to the `main` branch.
3. Wait for the GitHub Pages deployment to finish, then open the live page and confirm the update.
4. Check page navigation, mode images, Team Akagami downloads, sign-in, rooms, requests, guides, and scoreboards.

Supabase Auth must allow the live website URL and the redirect destinations used by the sign-in flow. Keep the Search Console HTML verification file in the repository while it is used to verify site ownership. The live database is separate from GitHub Pages; deploying HTML does not deploy or migrate the Supabase database.

## Troubleshooting

| Symptom | Checks |
| --- | --- |
| Catalog or guide says it could not load | Check internet access, the browser console/network panel, table name, grants, RLS `SELECT` policy, and whether the table exists in the Supabase schema cache. |
| Room list is empty or fails | Check the mode-specific rooms table, `status` values, read grants, and anonymous/authenticated RLS policies. |
| Create-room action fails | Confirm the user is signed in; check insert grants, the owner foreign key, required fields, and the table's `INSERT` policy. |
| Join request is denied | Confirm the room is eligible, the user is authenticated, and the requester/owner policies allow the intended action. |
| Scoreboard is empty | Confirm a room is selected and score rows reference the correct room ID; check score `SELECT` permissions and policy. |
| Images disappear after deployment | Check that assets were committed, paths are relative to the HTML file, and file name spelling/case matches exactly. |
| Sign-in works locally but not on the hosted site | Check Supabase Auth site URL and redirect allow-list for the deployed domain. |
| `supabase db pull` reports missing Docker/Podman | The CLI's schema-pull workflow may require a local container runtime. This is separate from serving the static website. |

## Known project limitations

- Adamantium is a community information hub; it does not connect to live War Thunder Mobile matches or game servers.
- The front end is static and communicates with Supabase from the browser; there is no custom application server in this version.
- The current saved SQL organization is not yet a proven automated fresh-database migration sequence.
- Formal test evidence and a completed deployment check should be recorded before presenting the project as production-ready.
- The project is a fan-made educational site and may use external services or media that require attribution and ongoing availability.

## Acknowledgements

- Supabase for hosted PostgreSQL, authentication, and the JavaScript client.
- MDN Web Docs for web-platform reference material.
- The creators and rights holders of any external images, fonts, and game-related materials used in the project. Add specific credits and license details for the assets actually included in the final repository.

---

**Project:** Adamantium  
**Purpose:** College software engineering assignment  
**Status:** Student project / fan-made community hub
