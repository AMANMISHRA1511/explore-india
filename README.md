# Explore India production UI

Public page: `index.html`  
Private/separate owner listing page: `business-portal.html`

## Backend
1. Run `supabase/india-national-seed.sql` in Supabase SQL Editor.
2. Open Supabase → Project Settings → API.
3. Copy the public `anon` key into `config.js`.
4. Never put the service-role key in frontend code.

The app loads published destinations from Supabase first and falls back to `data/india-destinations.json`.

## Deploy
Replace the files in the repository and push to `main`; Vercel redeploys automatically.
