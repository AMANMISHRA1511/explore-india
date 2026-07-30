# Explore India Production Portal

Static frontend connected to Supabase.

## Pages
- `index.html` destinations and advanced filters
- `listings.html` resorts, villas and businesses
- `business-portal.html` authentication and listing submission

## Local run
```bash
python -m http.server 8080
```

## Deploy
Import the repository into Vercel with framework preset **Other** and leave build command empty.

## Security
The browser uses only the Supabase publishable key. Never put Razorpay, Supabase service-role or other secret keys in frontend files. Payment verification must be implemented with a secure server or Supabase Edge Function.
