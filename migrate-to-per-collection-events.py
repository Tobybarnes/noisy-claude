#!/usr/bin/env python3
"""
Migrate config.json to per-collection event mappings structure.

Old structure:
{
  "collections": {...},
  "events": {...}  # Shared across all collections
}

New structure:
{
  "collections": {
    "default": {
      "events": {...}  # Sims2-specific mappings
    },
    "mgs": {
      "events": {...}  # MGS-specific mappings
    }
  }
}
"""

import json
from pathlib import Path

NOISY_CLAUDE_DIR = Path.home() / '.noisy-claude'
CURRENT_CONFIG = NOISY_CLAUDE_DIR / 'config.json'
SIMS2_BACKUP = NOISY_CLAUDE_DIR / 'config.json.pre-mgs-mapping'

# Read current config (has MGS mappings)
with open(CURRENT_CONFIG) as f:
    current = json.load(f)

# Read Sims2 backup (has Sims2 mappings)
with open(SIMS2_BACKUP) as f:
    sims2_backup = json.load(f)

# Extract shared event mappings
mgs_events = current.get('events', {})
sims2_events = sims2_backup.get('events', {})

# Move events into each collection
new_config = {
    'version': current.get('version', '2.0'),
    'focus_mode': current.get('focus_mode', 'always'),
    'active_collection': current.get('active_collection', 'default'),
    'collections': {}
}

# Copy collections and add their event mappings
for coll_id, coll_data in current.get('collections', {}).items():
    new_config['collections'][coll_id] = {
        'name': coll_data['name'],
        'path': coll_data['path'],
        'description': coll_data.get('description', '')
    }

    # Assign appropriate event mappings
    if coll_id == 'mgs':
        new_config['collections'][coll_id]['events'] = mgs_events
    elif coll_id == 'default':
        new_config['collections'][coll_id]['events'] = sims2_events
    else:
        # For any other collections, copy from current events
        new_config['collections'][coll_id]['events'] = mgs_events.copy()

# Write new config
with open(CURRENT_CONFIG, 'w') as f:
    json.dump(new_config, f, indent=2)
    f.write('\n')

print("✅ Successfully migrated config.json to per-collection event mappings")
print(f"\n📊 Migration summary:")
print(f"   • MGS collection: {len(mgs_events)} events")
print(f"   • Sims2 collection: {len(sims2_events)} events")
print(f"   • Active collection: {new_config['active_collection']}")
print(f"\n💾 Backup saved: config.json.before-per-collection-events")
