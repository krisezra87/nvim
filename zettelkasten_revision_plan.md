# Zettelkasten Revision Plan

## Structural Cleanup ✅ (mostly complete)

### index.md and zettel_index.md ✅
- [x] `index.md` cleaned to pure navigation hub
- [x] `zettel_index.md` scratch content removed; MoC clusters only
- [x] Personal scratch content moved to reference_notes/people/, projects/, lists/

### Zettelkasten Imposters ✅
- [x] `arch_audio_setup.md` → `reference_notes/`
- [x] `fixes/youtube_hardware_decode_fix.md` → `reference_notes/`
- [x] `golf_notes.md` → `reference_notes/`
- [x] `kyle_wedding.md` → `projects/`
- [x] `portugal.md` → `projects/`

### GTD Integration ✅
- [x] `projects/` folder created at vimwiki root
- [x] `lists/projects_list.md` created (Active / Someday/Maybe / Complete)
- [x] `lists/checklists/notes_reviews.md` updated with explicit list names

### Root Inbox ✅
- [x] Process or delete `anki_import.txt`
- [x] Process or delete `todoist_import.md`

---

## zettel.lua Consolidation ✅

### Template Generation ✅
- [x] Drop UltiSnips dependency — templates written natively via `nvim_buf_set_lines`
- [x] Cursor lands at body text area on open
- [x] `vimwiki.snippets` `zet` snippet kept as fallback

### Active Source ✅
- [x] Module-level variable: `active_source = { stub, title, rel_path }`
- [x] `<leader>zs` — sets from current file when in `notes/`, picker otherwise
- [x] `<leader>zS` — clear active source
- [x] `<leader>zr` — stamp active source into `## References` of current buffer
- [x] `<leader>zR` — one-shot picker: pick any notes file and stamp reference (no state change)
- [x] All creation commands auto-include active source in `## References` if set

### Commands consolidated from wikinote.vim ✅
- [x] `:Zet` — new zettel; splits vertically from `notes/`, edits in place elsewhere
- [x] `:ContZet` — new zettel + forward link inserted in current note's `## Links`
- [x] `:LinkLit` — new zettel from current book note (reference in `## References`)
- [x] `:LinkZet` — new zettel with back-link to current in `## Links`
- [x] `:ZI` — jump to zettel index

### Keymaps ✅
- [x] `<leader>z`  — open zettel index
- [x] `<leader>zz` — FZF search zettels (with bat preview)
- [x] `<leader>zl` — FZF insert zettel link (with bat preview)
- [x] `<leader>zb` — FZF backlinks (ripgrep current filename across zettelkasten)
- [x] `<leader>zt` — FZF add tag
- [x] `<leader>zT` — FZF tag search (two-step: pick tag → grep notes)
- [x] `<leader>zs` / `<leader>zS` / `<leader>zr` / `<leader>zR` — active source system

### Still to implement
- [x] `:ZetSummary` — scratch buffer of zettels referencing current notes file, sorted by Date
- [x] `:ZetOpenLoops` — Lua content check for non-empty `## Open Questions`; `## Open Questions` added to template; 13 existing zettels migrated to correct section order (Links → References → Open Questions)
- [x] `:RenameZettel` — rename file + ripgrep-replace all links across zettelkasten

### Leave in wikinote.vim ✅
- [x] `Note` / work notes commands kept; all zettel commands removed

### VimWiki Backspace Navigation Fix ✅
- [x] `<BS>` remapped to `<C-o>` in vimwiki buffers via FileType autocmd

```lua
vim.api.nvim_create_autocmd("FileType", {
    pattern = "vimwiki",
    callback = function()
        vim.keymap.set('n', '<BS>', '<C-o>', { buffer = true })
    end
})
```

Add this autocmd to zettel.lua.

---

## Bibliography Linking ✅
- [x] 135 zettels migrated from plain-text refs to `[[../notes/stem|Title]]` wikilinks
- [x] Stubs created for books without literature notes: influence, getting_things_done,
      reinforcement_learning_introduction, moonwalking_with_einstein, battle_hymn_of_the_tiger_mother
- [x] 3 non-book sources remain plain text (Udacity course, conversation, YouTube video) — intentional

---

## Tags ✅
- [x] `#zettel` status tag stripped from all notes (45 files)
- [x] `#seedling` and `#question` moved from Status to Tags (where they belong)
- [x] `#summary`, `#moc`, `#reference` cleared from Status fields
- [x] All Status fields now uniformly blank; Tags carry the meaningful labels
- [x] Empty `Status:` lines removed from all 195 zettels

### Tag / MoC relationship
`#[[tag_name]]` syntax in VimWiki is simultaneously a hashtag and a wikilink. A MoC emerges for free if you ever create `tag_name.md` — no extra work needed. MoC is never obligatory; only create one when tag search alone becomes insufficient for a dense topic cluster.

### Open Question tagging convention
- `## Open Questions` section is **ad-hoc** — added to a note only when there is content; never in the template
- Notes with an `## Open Questions` section carry `#[[open_question]]` in Tags for discoverability
- Workflow: `<leader>zT` → pick `open_question` → navigate to note → resolve → remove section and tag
- `:ZetOpenLoops` (Phase 2): greps for non-empty `## Open Questions` sections, opens results in fzf-lua

### Tag keymaps (zettel.lua)
- `<leader>zt` — FZF pick existing tag and INSERT into current note (unchanged)
- `<leader>zT` — NEW: FZF pick a tag, then show all notes containing it (two-step: tag picker → grep results)

---

## Bidirectionality
- Solved by `<leader>zb` backlinks function — no manual maintenance needed
- Obsidian graph remains available for visual exploration but is not part of active workflow

### Passive Backlink Display (Virtual Lines)
Problem: you don't know backlinks exist unless you actively check.

Solution: on `BufEnter` for any file in `zettelkasten/`, run ripgrep for the current filename stem and inject results as **virtual lines** below the last real line of the buffer. Cleared on `BufLeave`. Zero file modification — invisible to Zettel Notes and git.

Virtual text is not interactive (cursor skips it entirely). The two-tool model:
- **Virtual lines** — passive awareness; you see "← craftsman_mindset, career_capital" automatically
- **`<leader>zb`** — interactive; opens fzf-lua on those same results so you can navigate to one

Implementation notes:
- Use `nvim_buf_set_extmark` with `virt_lines` option on a dedicated namespace
- Run ripgrep async (non-blocking) via `vim.system` or `jobstart`
- Clear the namespace on `BufLeave` to avoid stale lines when switching buffers
- Format: one virtual line reading `← backlinked from: note_a, note_b, note_c` (dimmed highlight group)

---

## Pipeline (Revised Understanding)

Ahrens intends a continuous, small-batch process — not end-of-book synthesis:

1. **Fleeting notes** — paper or phone during reading; process within a day or two
2. **Literature notes** — brief, in own words, written same day; lives in `notes/` file which grows with the book
3. **Permanent zettels** — one idea per note, written from literature notes the next day; linked immediately into zettelkasten

Changes from current practice:
- [ ] Stop waiting until end of book to synthesize; write zettels continuously during reading
- [ ] `notes/` files are living literature notes, not summaries — lighter treatment for new books
- [ ] Separate summary files are eliminated; the zettels accumulate to form the summary organically

### Book Notes as Literature Notes
- The `notes/` file for each book grows as you read (add to it per session)
- Each zettel's `## References` links back to the notes file (via active source)
- "Summary" is generated dynamically by harvesting backlinks — no separate file needed

### :ZetSummary Command (NEW)
- Run from a `notes/` file
- Finds all zettels whose `## References` section links to the current file
- Opens a scratch buffer listing them sorted by Date field (chronological reading order)
- This replaces the written summary file entirely

---

## Zettel Addressing

### The Problem
Luhmann's physical IDs (1a2b3c) decoupled the address from the title — links used the ID, content could be retitled freely. In the current system the filename is both the stable address and the human-readable label, creating pressure to get the name "right" from the start.

### Two Approaches

**Option A: Rename-aware tooling (for existing notes)**
- Keep descriptive filenames
- Add `:RenameZettel` command: renames file + ripgrep-and-replace all links across zettelkasten
- Renaming becomes a single safe command; immutability pressure disappears
- Recommended for existing ~200 notes

**Option B: Timestamp IDs (for new notes, optional)**
- Filenames become `202501301423.md`
- Title lives only in H1 heading; links use `[[202501301423|attention residue]]`
- Address is immutable; display text and H1 can change freely
- FZF search modified to display H1 titles instead of filenames

### Implementation Tasks ✅
- [x] Add `:RenameZettel` command to zettel.lua — rename file + update all links via ripgrep
- [x] Decided: descriptive filenames + `:RenameZettel` tooling only; timestamp IDs unnecessary since rename is now safe

### Obsidian Compatibility
- By default Obsidian graph shows filenames — timestamp IDs would display as opaque numbers
- Fix: enable "Use title from first heading" in Obsidian Settings > Editor (app.json: `"showInlineTitle": true`) OR add `title` frontmatter property to each zettel
- Prerequisite: configure Obsidian before switching to timestamp IDs
- [ ] Verify which Obsidian setting controls graph display titles and enable it

---

## Open Questions
- [ ] MoC: when and whether to create them — see notes below

## Resolved
- **Project notes** → new `projects/` folder at the vimwiki root, alongside `lists/` and `reference_notes/`
- **Zettel addressing** → descriptive filenames + `:RenameZettel` tooling only; timestamp stays as the `Date:` field inside the file (not in the filename); no timestamp IDs
- **Filename conventions** → all zettelkasten files `lowercase_with_underscores`; no hyphens; book hub notes carry `_summary` suffix (e.g. `deep_work_summary.md`) to distinguish from concept zettels; `q_` prefix removed from question files (tag handles it)
- **All `## References` migrated** → wikilinks to `notes/`; stubs created for Influence, GTD, RL, Moonwalking, Battle Hymn
- **Structural homogenization complete** → every content file has `Date`/`Tags`/`## Links`/`## References`; `Status:` field removed entirely (195 files); navigation files (zettel_index, book_summaries, politics MoC, zettelkasten MoC) intentionally excluded
- **Open questions** → `## Open Questions` ad-hoc section + `#[[open_question]]` tag; not in template; 13 existing files tagged
- **Backlinks** → no manual maintenance; `<leader>zb` (interactive) + virtual lines on BufEnter (passive, Phase 2)
