# Quick Start: Collections System

Get started with multiple sound libraries in 5 minutes.

## What Are Collections?

Collections let you manage multiple sound libraries and switch between them instantly. Think of them as "themes" or "sound packs" for noisy-claude.

## Quick Setup

### Step 1: Launch Control Panel

```bash
~/.noisy-claude/launch-control-panel.sh
```

Then open: **http://localhost:5050**

### Step 2: Add Your First Collection

1. **Prepare your sounds**
   - Put audio files in a folder (e.g., `~/Music/my-sounds/`)
   - Supported formats: WAV, MP3, AIFF, M4A

2. **In the Control Panel**
   - Click the **"Add Collection"** button (top right)
   - Fill in the form:
     - **Name**: Give it a friendly name (e.g., "Retro Games")
     - **Path**: Paste the full path (e.g., `/Users/username/Music/my-sounds`)
     - **Description**: Optional note

3. **Scan and Suggest**
   - Click **"Scan Folder"** to verify the path
   - See how many audio files were found
   - Click **"Claude Suggests Mappings"** for automatic assignments
   - Review the suggestions with confidence scores

4. **Save**
   - Click **"Save Collection"**
   - Your new collection is ready!

### Step 3: Switch Collections

Use the dropdown in the header to switch between collections instantly.

## Example Scenarios

### Scenario 1: Try Different Sound Themes

```
1. Download a UI sound pack to ~/Downloads/ui-sounds/
2. Add Collection: "UI Sounds" → ~/Downloads/ui-sounds/
3. Scan → 30 files found
4. Claude Suggests → 25 automatic mappings
5. Save
6. Switch to "UI Sounds" in dropdown
7. Try it out! Trigger some events
8. Switch back to "Sims Sounds" if you prefer
```

### Scenario 2: Create a Silent Collection

```
1. Create an empty folder: mkdir ~/silent-sounds
2. Add Collection: "Silent Mode" → ~/silent-sounds/
3. Save (skip suggestions since folder is empty)
4. Switch to "Silent Mode" when you need focus
5. No sounds will play!
```

### Scenario 3: Share with Team

```
1. Put sounds in shared Dropbox folder
2. All team members add same collection
3. Everyone hears the same sounds
4. Update sounds in Dropbox to update for everyone
```

## Smart Filename Matching

Claude can automatically map sounds to events based on filename keywords:

| Filename | Suggested Event | Confidence |
|----------|----------------|------------|
| `error.wav` | tool_failure | 95% |
| `success.wav` | tool_success | 95% |
| `commit.wav` | git_commit | 95% |
| `test-pass.wav` | test_pass | 90% |
| `greeting.wav` | session_start | 95% |
| `celebration.wav` | git_pr_create | 90% |
| `alert.wav` | context_90 | 85% |
| `happy.wav` | streak_5 | 85% |

**Tips:**
- Use descriptive filenames
- Keywords can be anywhere in the filename
- The algorithm is smart but not perfect
- You can always assign sounds manually after saving

## Command Line

### Check Current Collection

```bash
~/.noisy-claude/noisy-claude.sh --status
```

Shows:
```
Active collection: default
  Name: Sims Sounds
  Path: /Users/username/.noisy-claude/sounds

Total collections: 2
  → default: Sims Sounds
    custom: My Custom Sounds
```

### List Sounds from Active Collection

```bash
~/.noisy-claude/noisy-claude.sh --list-sounds
```

### Play a Sound

```bash
~/.noisy-claude/noisy-claude.sh --play "sound.wav"
```

Plays from the currently active collection.

## Common Questions

### Can I use sounds from multiple collections at once?

No, only one collection is active at a time. But you can switch instantly!

### What happens to my event mappings when I switch?

Your event-to-sound mappings are preserved. When you switch collections, noisy-claude looks for those same sound filenames in the new collection. If a sound isn't found, that event won't play.

### Can I delete a collection?

Yes, but you can't delete the currently active collection. Switch to another collection first.

### How do I rename a collection?

Edit `~/.noisy-claude/config.json` directly and change the `name` field.

### Can I have different mappings per collection?

Not currently. All collections share the same event mappings. You'd need to manually update mappings after switching.

### Where are collections stored?

In `~/.noisy-claude/config.json` under the `collections` key.

## Best Practices

1. **Use descriptive names** - "Retro Gaming Sounds" is better than "Collection 2"
2. **Add descriptions** - Future you will thank you
3. **Organize your sounds** - Keep sound files in dedicated folders
4. **Name files descriptively** - Helps with Claude Suggests
5. **Test before sharing** - Switch to a collection and trigger some events
6. **Keep a backup** - Copy your `config.json` occasionally

## Troubleshooting

### "Path does not exist" error

- Double-check the path is absolute (starts with `/`)
- Verify the folder actually exists
- Check for typos in the path

### No audio files found

- Make sure files have supported extensions: `.wav`, `.mp3`, `.aiff`, `.m4a`
- Check the files are directly in the folder (not in subfolders)

### Collection won't switch

- Refresh the control panel page
- Check that collection still exists in the config
- Try restarting the control panel server

### Sounds not playing after switching

- Verify the new collection has the required sound files
- Check that filenames match your event mappings
- Run `--list-sounds` to see what's in the active collection

## Next Steps

- Read [COLLECTIONS.md](COLLECTIONS.md) for detailed documentation
- Try the API endpoints to integrate with your own tools
- Share your favorite sound collections with the team

Enjoy your multi-collection sound experience!
