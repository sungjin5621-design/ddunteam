ddunteam v40.6 FINAL FIX11

- Distribution/payment state persisted to Supabase clan_private_state (state_key=distribution)
- Existing local distribution data is migrated to the shared state on first load when possible
- Payment status survives refresh
- Distribution notes persist
- Operating memo is a cafe-style append-only history with author/date/time and Supabase persistence
- Existing member-management ordering is preserved
- Ladder all-results handler retained

Deployment: replace the existing index.html only.
No new SQL is required if clan_private_state is already available to the existing app.
