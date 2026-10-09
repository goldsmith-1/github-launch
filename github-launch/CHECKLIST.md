# Launch checklist

**Before you publish**
- [ ] Unzip every project into one folder, plus the `goldsmith-1` folder from this pack
- [ ] **Miaoyi:** replace my reference code with your real implementation wherever yours is stronger, and make sure the README matches what you actually built
- [ ] Make sure no real keys or `.env` files are in any folder (the script also checks)
- [ ] Add your contact line at the bottom of `goldsmith-1/README.md`
- [ ] Decide whether to keep your Miva matric number and personal details out of every repo (they are not in the files I wrote)

**Publish**
1. Install git and the GitHub CLI, then run `gh auth login`
2. Preview: `DRY_RUN=1 bash publish-all.sh /path/to/folder`
3. For real: `bash publish-all.sh /path/to/folder`
4. Pin the six repos: profile page, Customize your pins

**After publishing**
- [ ] Open each demo link and test it on your phone (Pages can take a few minutes after the first push)
- [ ] Add a screenshot or GIF to every README (a 10 second screen recording is enough)
- [ ] Test Page to Voice offline: load it, switch to airplane mode, reload
- [ ] Run your own games through Go Coach with real KataGo and note what you learn
- [ ] Set up a free account on a host such as Render or Fly.io if you later want a live Miaoyi API
- [ ] When you finish a study, add the real results to that README and to the profile page, and not before
