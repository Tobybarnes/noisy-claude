# Collections System

The Collections System allows you to manage multiple sound libraries in noisy-claude and easily switch between them.

## Overview

Each collection points to a folder containing sound files. You can have multiple collections (e.g., "Sims Sounds", "UI Sounds", "Retro Games", "Sci-Fi") and switch between them at any time. The active collection determines which sounds are available for your events.

## Configuration Structure

Collections are stored in `config.json`:

```json
{
  "version": "2.0",
  "focus_mode": "always",
  "active_collection": "default",
  "collections": {
    "default": {
      "name": "Sims Sounds",
      "path": "/Users/username/.noisy-claude/sounds",
      "description": "Original Sims game sounds"
    },
    "custom": {
      "name": "My Custom Sounds",
      "path": "/Users/username/Music/notifications",
      "description": "Custom notification sounds"
    }
  },
  "events": { ... }
}
```

## Using the Control Panel

### Switching Collections

1. Open the Control Panel: `~/.noisy-claude/launch-control-panel.sh`
2. In the header, find the "Collection" dropdown
3. Select a different collection to switch
4. All sounds will now be loaded from the new collection's folder

### Adding a New Collection

1. Click the "Add Collection" button in the header
2. Fill in the form:
   - **Collection Name**: A friendly name (e.g., "Retro Games")
   - **Folder Path**: Absolute path to the folder containing sound files
   - **Description**: Optional description
3. Click "Scan Folder" to verify the path and see how many audio files were found
4. Click "Claude Suggests Mappings" to automatically match filenames to events
5. Review the suggestions (shows confidence scores)
6. Click "Save Collection" to add it

### Smart Filename Matching

Claude can intelligently match sound filenames to events based on keywords. Examples:

- `error.wav` → tool_failure (95% confidence)
- `success.wav` → tool_success (95% confidence)
- `celebration.wav` → git_pr_create (90% confidence)
- `greeting.wav` → session_start (95% confidence)
- `tired.wav` → late_night (90% confidence)

The algorithm looks for these keywords and their variations:
- **Error/Failure**: error, fail, failure, bad, oops, sad, mad
- **Success**: success, complete, done, good, nice, happy, celebrate
- **Git**: commit, push, pull, merge
- **Testing**: test, pass, fail
- **Build**: build, compile
- **Time**: morning, afternoon, evening, night, tired
- **Agent**: agent, team, message, chat
- And many more...

## Supported Audio Formats

- `.wav` (recommended)
- `.mp3`
- `.aiff`
- `.m4a`

## Command Line Usage

### Check Current Collection

```bash
~/.noisy-claude/noisy-claude.sh --status
```

Shows:
- Active collection name and path
- Total collections available
- All collections with marker (→) for active

### List Sounds from Active Collection

```bash
~/.noisy-claude/noisy-claude.sh --list-sounds
```

### Play a Sound from Active Collection

```bash
~/.noisy-claude/noisy-claude.sh --play "sound-file.wav"
```

## API Endpoints

The Control Panel Server provides these REST endpoints:

### GET `/api/collections`
List all collections and get the active one.

**Response:**
```json
{
  "collections": { ... },
  "active_collection": "default"
}
```

### POST `/api/collections`
Add a new collection.

**Request:**
```json
{
  "id": "my_collection",
  "name": "My Collection",
  "path": "/path/to/sounds",
  "description": "Optional description"
}
```

### DELETE `/api/collections/{id}`
Delete a collection (cannot delete active collection).

### PUT `/api/collections/active`
Set the active collection.

**Request:**
```json
{
  "collection_id": "my_collection"
}
```

### POST `/api/collections/scan`
Scan a folder for audio files.

**Request:**
```json
{
  "path": "/path/to/folder"
}
```

**Response:**
```json
{
  "status": "success",
  "count": 25,
  "files": ["sound1.wav", "sound2.wav", ...]
}
```

### POST `/api/collections/suggest`
Get smart filename-to-event mappings.

**Request:**
```json
{
  "files": ["error.wav", "success.wav", "greeting.wav"]
}
```

**Response:**
```json
{
  "status": "success",
  "matched_count": 3,
  "suggestions": {
    "error.wav": {
      "event": "tool_failure",
      "confidence": 95,
      "keyword": "error"
    },
    "success.wav": {
      "event": "tool_success",
      "confidence": 95,
      "keyword": "success"
    },
    "greeting.wav": {
      "event": "session_start",
      "confidence": 95,
      "keyword": "greeting"
    }
  }
}
```

## Use Cases

### Scenario 1: Theme-Based Collections

Create different collections for different moods or projects:

- **"Productive"**: Subtle, minimal sounds
- **"Playful"**: Fun, energetic Sims sounds (default)
- **"Retro"**: 8-bit game sounds
- **"Sci-Fi"**: Futuristic UI sounds
- **"Silent"**: Point to an empty folder for silent work

### Scenario 2: Shared Team Sounds

- Create a collection pointing to a shared Dropbox/Google Drive folder
- Team members all add the same collection
- Any team member can update the shared sounds

### Scenario 3: Project-Specific Sounds

- Create a collection per project
- Switch collections when switching projects
- Each project has its own audio personality

## Validation

The system validates:
- Folder exists and is readable
- No duplicate collection names
- Cannot delete the active collection
- Only scans for supported audio formats
- Shows warning if no audio files found

## Technical Notes

- Collections are stored in `config.json`
- The active collection path is resolved dynamically at runtime
- All noisy-claude scripts (noisy-claude.sh, agent-sound.sh) support collections
- Sound paths are resolved from the active collection on each event
- Switching collections does not require restarting Claude Code
- The Control Panel automatically reloads sounds when switching

## Migration from v1.0

If you're upgrading from noisy-claude v1.0:

1. Your existing sounds in `~/.noisy-claude/sounds` are automatically preserved
2. A default collection is created pointing to this folder
3. All your existing sound mappings remain unchanged
4. You can now add additional collections as needed

## Troubleshooting

### Collection not switching
- Refresh the Control Panel page
- Check that the collection path still exists
- Verify the collection has audio files

### Sounds not playing
- Run `--status` to verify the active collection path
- Run `--list-sounds` to see if sounds are found
- Check file permissions on the collection folder

### Smart suggestions not working
- Ensure your filenames contain descriptive keywords
- Manual assignment always works as fallback
- You can create custom mappings after saving

## Example Workflow

1. Download a sound pack to `~/Music/ui-sounds/`
2. Open Control Panel
3. Click "Add Collection"
4. Name: "UI Sounds", Path: `/Users/username/Music/ui-sounds`
5. Click "Scan Folder" → sees 30 files
6. Click "Claude Suggests Mappings" → gets 25 matches
7. Review the suggestions
8. Click "Save Collection"
9. Select "UI Sounds" from the dropdown
10. All events now use sounds from the new collection

Enjoy your multi-collection sound experience!
