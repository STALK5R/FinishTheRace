# Finish The Race Motorsports

Custom Cloudflare Worker website, ready to place in a GitHub repository.
This is the initial website foundation, not a completed commerce system.

Start with **DEPLOYMENT.md** for the GitHub → Cloudflare setup.

## Included

- Both supplied logos; blue/red/black responsive homepage and page layouts.
- About, events/calendar (including calendar downloads), gallery/lightbox and shop.
- Product concepts and preview shopping bag. Checkout is intentionally disabled.
- Password-protected admin content editor; signed eight-hour HttpOnly secure sessions.
- R2-backed content, photos/videos, contact inbox and newsletter signup records.
- Same-origin write protection, guarded admin APIs and Cloudflare rate limiting.
- Node build scripts, Wrangler configuration and eight backend tests.

## Not implemented yet

Customer email/password accounts, required customer name/address profiles, email
verification/recovery, live checkout, stock/variants, order handling/history,
shipping/tax calculations, refunds, receipts, newsletter sending/unsubscribe,
and final business-specific policies still need implementation/configuration.
The customer account control and checkout tell visitors they are not available.
Forms save records but do not send emails. The privacy page is clearly a draft.

## Editing

- worker/app.js: Worker API, base content, HTML layout, CSS.
- worker/client.js: client pages, forms, content editor and preview bag.
- worker/brand.json: original supplied logos encoded into the Worker.
- worker/index.js: generated from the three sources above; do not edit directly.
- scripts/build.mjs: assembles the deployable Worker using Node only.
- wrangler.jsonc: Cloudflare configuration (Worker name, R2 and rate limit bindings).

Build with `npm run build`. Test with `npm test`. Develop with `npm run dev`.
For local admin testing, copy `dev-vars-example.txt` to `.dev.vars` and set unique
values. Local HTTP development may differ from production secure-cookie behavior;
verify admin sign-in on the HTTPS workers.dev deployment.

## Data and access

R2 binding: BUCKET. The bucket must exist before deployment. No D1 database is
needed for this foundation; later customer/order functionality may add D1.
Content writes use ETag checks to reject conflicting saves from multiple tabs.
Inbox/subscriber views show up to 200 records; pagination/export remains future work.
Media uploads are up to 35 MiB and accept JPEG, PNG, WebP, MP4 or WebM.
Public R2 bucket access is not required. The Worker serves only media/ objects,
not inbox/, newsletter/ or site/ object keys.

Keep ADMIN_PASSWORD and ADMIN_SESSION_SECRET in Cloudflare runtime secrets.
Changing either invalidates existing admin sessions. Logging out clears the browser
cookie. Rate limits are local to a Cloudflare edge location, not a global quota;
shared IPs may share limits. This is not a claim of a full security audit.

No Cloudflare/GitHub credentials, ChatGPT auth dependency or Sites project identity
are included. The standalone deployment starts from the supplied default content;
any later content/media saved in the separate ChatGPT-hosted preview is not copied.
