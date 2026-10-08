# GitHub → Cloudflare deployment

Use **Cloudflare Workers**, not a static-only Pages deployment: this project has
server APIs and R2 storage.

## 1. Put the files in GitHub

1. Extract the ZIP.
2. Create a GitHub repository named `finish-the-race-motorsports` (private is fine).
3. Upload the extracted FILES AND FOLDERS into the repository root.
   `package.json`, `wrangler.jsonc`, `worker/`, and `scripts/` should be visible
   directly in the root, not nested in another project folder.
4. Commit them to the `main` branch.

The archive intentionally omits dotfiles to make GitHub's browser uploader easier.
The included `gitignore.txt` lists exclusions. If working with Git locally, rename
it to `.gitignore` before installing packages or creating local secret files.
The example local secret file is named `dev-vars-example.txt`; do not put actual
secrets into GitHub.

## 2. Create the storage bucket

In your Cloudflare account, open R2 and create a bucket named:

`finish-the-race-media`

Leave public bucket access disabled. The Worker serves uploaded media itself.
The `BUCKET` binding is already declared in `wrangler.jsonc`.
If using a different bucket name, change `bucket_name` in that file before deploying.

## 3. Connect the repository to Workers

In Cloudflare's Workers & Pages area, create a Worker using the option to import
an existing Git repository. Connect GitHub and select this repository.

Set:

| Setting | Value |
| --- | --- |
| Worker/project name | finish-the-race-motorsports |
| Production branch | main |
| Root directory | Repository root (blank or `/`) |
| Build command | npm run build |
| Deploy command | npx wrangler deploy |
| Dependency installation | npm install (the normal automatic install is sufficient) |
| Node version | 22 or newer |

The dashboard labels can change. Select the Git-connected **Worker** workflow.
Worker name must match `name` in `wrangler.jsonc`; update that file if you rename it.
No account ID or API token needs to be committed for the native Git connection.

The configuration also declares LOGIN_LIMITER and FORM_LIMITER. The numeric
namespace IDs are account-local identifiers. If they conflict with identifiers
already used by another Worker in your account, choose two unused positive
integer strings before deploying.

## 4. Set the admin runtime secrets

In the deployed Worker's Settings → Variables and Secrets, add these as secrets:

| Secret name | Value you choose |
| --- | --- |
| ADMIN_PASSWORD | A unique admin password of at least 16 characters |
| ADMIN_SESSION_SECRET | At least 32 random characters; preferably a generated 64-character secret |

These are runtime secrets, not ordinary plaintext GitHub files or build variables.
Save/apply the settings and redeploy if Cloudflare prompts you.
Until both are configured, admin login fails closed. Public pages still load.

Open the HTTPS workers.dev URL. Click **Manage website** in the footer, or visit:

`https://YOUR-WORKER-URL/#/admin`

Sign in with ADMIN_PASSWORD. No ChatGPT account is needed. This admin login is
separate from the future customer email/password account system.

## 5. Verify the deployed website

- Homepage and supplied logos display.
- Admin login works; wrong passwords are rejected.
- Change a homepage line, save, and refresh to confirm persistence.
- Add a sample event and image; check the public events/gallery pages.
- Submit a contact message and check Messages in admin.
- Submit a newsletter signup and check Newsletter in admin.
- Confirm checkout stays disabled; this version cannot take real orders.

Updating the main branch triggers the connected Cloudflare build/deployment.
Do not connect both Workers Builds and another automatic deploy workflow to the
same branch unless you intentionally want both.

## 6. Optional custom domain

After the workers.dev deployment is working, use the Worker's custom-domain
settings to attach your domain. No domain is hardcoded into this build.

## CLI alternative

With Node 22+ installed, open a terminal in the extracted project:

```sh
npm install
npx wrangler login
npx wrangler r2 bucket create finish-the-race-media
npx wrangler secret put ADMIN_PASSWORD
npx wrangler secret put ADMIN_SESSION_SECRET
npm test
npm run deploy
```

Skip bucket creation if it already exists. Secret commands prompt for values;
do not put their values in shell commands or source files.

## Launch status

This package deploys the initial design/content foundation. Before selling:
finish customer accounts, stock/variants, Stripe checkout and webhooks,
order handling, shipping/tax rules, email delivery and final policies.
No payment-provider keys are needed merely to deploy this foundation.

## Official references

- https://developers.cloudflare.com/workers/ci-cd/builds/
- https://developers.cloudflare.com/workers/wrangler/configuration/
- https://developers.cloudflare.com/workers/runtime-apis/bindings/rate-limit/
- https://developers.cloudflare.com/workers/configuration/secrets/
