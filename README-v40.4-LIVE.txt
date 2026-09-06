ddunteam v40.6 MEMO ACCESS FALLBACK FIX

What changed
- Fixes the memo page crash that prevented the v40 feature layer from rendering.
- Adds visible paid / unpaid status beside every nickname, with a green paid row.
- Adds a payment / cancel button and records the payer and time.
- Adds a small memo button beside every nickname for distribution notes.
- Adds rank, standard, level, and 가나다 sorting plus paid / unpaid filtering.
- Grants all distribution actions to the page owner, 군주, and 관리자.
- Applies the same rule to the older memo fallback, preventing its access-denied blank page.
- Keeps every other existing page unchanged.

Deploy
1. If you already ran the v39 distribution SQL successfully, you do not need to run SQL again.
2. If payment buttons say that the distribution database is not ready, run the entire
   supabase_v40.4_MEMO_SAFE.sql file once in Supabase SQL Editor. It only creates or
   adds missing structures; it does not delete existing data.
3. Replace only the current GitHub index.html with this ZIP's index.html.
4. Commit to main and wait for Vercel deployment.
5. Open the site with Ctrl + F5.

Expected memo screen
- A v40.4 badge is shown next to '뚠뚠 메모장'.
- Sort and status filter buttons appear directly under '분배금 관리'.
- Each member has a 🟢 지급완료 or 🟡 미지급 badge, a 지급/지급취소 button,
  and a 📝 note button.
