#!/usr/bin/env python3
"""
Noisy Claude Control Panel Server
A simple Flask server for managing Noisy Claude configuration
"""

import json
import os
import subprocess
from pathlib import Path
from flask import Flask, jsonify, request, send_from_directory
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

NOISY_CLAUDE_DIR = Path(os.environ.get('NOISY_CLAUDE_DIR', Path.home() / '.noisy-claude'))
CONFIG_FILE = NOISY_CLAUDE_DIR / 'config.json'
SOUNDS_DIR = NOISY_CLAUDE_DIR / 'sounds'

@app.route('/')
def index():
    return send_from_directory(NOISY_CLAUDE_DIR, 'control-panel.html')

@app.route('/api/config', methods=['GET'])
def get_config():
    """Get current configuration - flatten events from active collection"""
    with open(CONFIG_FILE) as f:
        config = json.load(f)

    # Flatten structure: pull active collection's events to top level for backward compatibility
    active_collection = config.get('active_collection', 'default')
    collections = config.get('collections', {})

    if active_collection in collections and 'events' in collections[active_collection]:
        # Return flattened config with events from active collection
        flat_config = {
            'version': config.get('version'),
            'focus_mode': config.get('focus_mode'),
            'master_enabled': config.get('master_enabled', True),
            'volume': config.get('volume', 100),
            'active_collection': active_collection,
            'collections': collections,
            'events': collections[active_collection]['events']
        }
        return jsonify(flat_config)

    # Fallback for old structure
    return jsonify(config)

@app.route('/api/config', methods=['POST'])
def save_config():
    """Save configuration - save events to active collection"""
    incoming = request.json

    # Read current config to preserve structure
    with open(CONFIG_FILE) as f:
        config = json.load(f)

    # Update top-level fields
    if 'focus_mode' in incoming:
        config['focus_mode'] = incoming['focus_mode']
    if 'version' in incoming:
        config['version'] = incoming['version']
    if 'master_enabled' in incoming:
        config['master_enabled'] = incoming['master_enabled']
    if 'volume' in incoming:
        config['volume'] = incoming['volume']

    # Save events to active collection
    active_collection = config.get('active_collection', 'default')
    if active_collection in config.get('collections', {}):
        if 'events' in incoming:
            config['collections'][active_collection]['events'] = incoming['events']

    with open(CONFIG_FILE, 'w') as f:
        json.dump(config, f, indent=2)
        f.write('\n')
    return jsonify({'status': 'success'})

@app.route('/api/sounds', methods=['GET'])
def get_sounds():
    """List all available sounds from active collection"""
    with open(CONFIG_FILE) as f:
        config = json.load(f)

    active_collection = config.get('active_collection', 'default')
    collections = config.get('collections', {})

    if active_collection in collections:
        sounds_path = Path(collections[active_collection]['path'])
    else:
        sounds_path = SOUNDS_DIR

    if sounds_path.exists():
        sounds = sorted([f.name for f in sounds_path.iterdir() if f.is_file() and f.suffix in ['.wav', '.mp3', '.aiff', '.m4a']])
    else:
        sounds = []

    return jsonify(sounds)

@app.route('/api/sf2-wallpaper')
def sf2_wallpaper():
    """Serve the SF2 wallpaper image for the theme background"""
    sf2_path = SOUNDS_DIR / 'SF2'
    return send_from_directory(sf2_path, 'wallpaper-ryus-stage.jpg')

@app.route('/api/mgs-wallpaper')
def mgs_wallpaper():
    """Serve the MGS wallpaper image for the theme background"""
    mgs_path = SOUNDS_DIR / 'MGS'
    return send_from_directory(mgs_path, 'mgs-wallpaper.jpg')

@app.route('/api/2001-wallpaper')
def hal_wallpaper():
    """Serve the 2001 wallpaper image for the theme background"""
    hal_path = SOUNDS_DIR / '2001-archive-sounds'
    return send_from_directory(hal_path, 'thumb-1920-656468.jpg')

@app.route('/api/play-sound', methods=['POST'])
def play_sound():
    """Play a sound file from active collection"""
    sound_file = request.json.get('sound')

    with open(CONFIG_FILE) as f:
        config = json.load(f)

    active_collection = config.get('active_collection', 'default')
    collections = config.get('collections', {})

    if active_collection in collections:
        sounds_path = Path(collections[active_collection]['path'])
    else:
        sounds_path = SOUNDS_DIR

    sound_path = sounds_path / sound_file

    if sound_path.exists():
        # Apply volume setting
        volume = config.get('volume', 100) / 100.0
        subprocess.Popen(['afplay', '-v', str(volume), str(sound_path)], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        return jsonify({'status': 'success'})

    return jsonify({'status': 'error', 'message': 'Sound file not found'}), 404

@app.route('/api/collections', methods=['GET'])
def get_collections():
    """Get all collections"""
    with open(CONFIG_FILE) as f:
        config = json.load(f)
    return jsonify({
        'collections': config.get('collections', {}),
        'active_collection': config.get('active_collection', 'default')
    })

@app.route('/api/collections', methods=['POST'])
def add_collection():
    """Add a new collection"""
    data = request.json
    collection_id = data.get('id')
    collection_name = data.get('name')
    collection_path = data.get('path')
    collection_description = data.get('description', '')

    if not collection_id or not collection_name or not collection_path:
        return jsonify({'status': 'error', 'message': 'Missing required fields'}), 400

    # Validate path exists
    path = Path(collection_path)
    if not path.exists() or not path.is_dir():
        return jsonify({'status': 'error', 'message': 'Path does not exist or is not a directory'}), 400

    with open(CONFIG_FILE) as f:
        config = json.load(f)

    if 'collections' not in config:
        config['collections'] = {}

    # Check for duplicate names
    for cid, coll in config['collections'].items():
        if coll['name'] == collection_name and cid != collection_id:
            return jsonify({'status': 'error', 'message': 'Collection name already exists'}), 400

    config['collections'][collection_id] = {
        'name': collection_name,
        'path': collection_path,
        'description': collection_description
    }

    with open(CONFIG_FILE, 'w') as f:
        json.dump(config, f, indent=2)
        f.write('\n')

    return jsonify({'status': 'success', 'collection_id': collection_id})

@app.route('/api/collections/<collection_id>', methods=['DELETE'])
def delete_collection(collection_id):
    """Delete a collection"""
    with open(CONFIG_FILE) as f:
        config = json.load(f)

    if collection_id not in config.get('collections', {}):
        return jsonify({'status': 'error', 'message': 'Collection not found'}), 404

    # Prevent deleting the active collection
    if config.get('active_collection') == collection_id:
        return jsonify({'status': 'error', 'message': 'Cannot delete active collection'}), 400

    del config['collections'][collection_id]

    with open(CONFIG_FILE, 'w') as f:
        json.dump(config, f, indent=2)
        f.write('\n')

    return jsonify({'status': 'success'})

@app.route('/api/collections/active', methods=['PUT'])
def set_active_collection():
    """Set the active collection"""
    data = request.json
    collection_id = data.get('collection_id')

    with open(CONFIG_FILE) as f:
        config = json.load(f)

    if collection_id not in config.get('collections', {}):
        return jsonify({'status': 'error', 'message': 'Collection not found'}), 404

    config['active_collection'] = collection_id

    with open(CONFIG_FILE, 'w') as f:
        json.dump(config, f, indent=2)
        f.write('\n')

    return jsonify({'status': 'success'})

@app.route('/api/collections/scan', methods=['POST'])
def scan_collection():
    """Scan a folder for audio files"""
    data = request.json
    folder_path = data.get('path')

    if not folder_path:
        return jsonify({'status': 'error', 'message': 'Path is required'}), 400

    path = Path(folder_path)
    if not path.exists() or not path.is_dir():
        return jsonify({'status': 'error', 'message': 'Path does not exist or is not a directory'}), 400

    # Scan for audio files
    audio_extensions = ['.wav', '.mp3', '.aiff', '.m4a']
    audio_files = []
    for ext in audio_extensions:
        audio_files.extend([f.name for f in path.glob(f'*{ext}')])

    audio_files.sort()

    return jsonify({
        'status': 'success',
        'count': len(audio_files),
        'files': audio_files
    })

@app.route('/api/collections/suggest', methods=['POST'])
def suggest_mappings():
    """Generate smart mappings from filenames to events"""
    data = request.json
    audio_files = data.get('files', [])

    # Filename pattern keywords to event mappings
    FILENAME_PATTERNS = {
        'error': ['tool_failure', 'git_error', 'build_error', 'test_fail'],
        'fail': ['tool_failure', 'test_fail', 'build_error'],
        'failure': ['tool_failure', 'build_error', 'test_fail'],
        'success': ['tool_success', 'git_commit', 'git_push', 'test_pass', 'build_complete'],
        'complete': ['task_complete', 'build_complete'],
        'done': ['task_complete', 'background_task_done'],
        'start': ['session_start', 'subagent_start'],
        'begin': ['session_start', 'plan_mode_enter'],
        'stop': ['session_end', 'subagent_stop'],
        'end': ['session_end'],
        'notification': ['permission', 'teammate_message'],
        'notify': ['teammate_message', 'permission'],
        'alert': ['error_threshold', 'context_90', 'context_75'],
        'warning': ['long_task', 'context_75', 'error_threshold'],
        'happy': ['streak_3', 'streak_5', 'git_pr_create', 'subagent_start'],
        'celebrate': ['git_pr_create', 'streak_10', 'streak_5'],
        'sad': ['tool_failure', 'git_error', 'test_fail'],
        'oops': ['tool_failure', 'git_error'],
        'greeting': ['session_start', 'morning'],
        'hello': ['session_start', 'morning'],
        'goodbye': ['session_end'],
        'bye': ['session_end'],
        'tired': ['late_night', 'long_task', 'thinking_long'],
        'waiting': ['permission', 'thinking_medium'],
        'wait': ['permission', 'thinking_short'],
        'think': ['thinking_medium', 'thinking_long'],
        'hungry': ['context_75', 'context_90'],
        'snack': ['context_50'],
        'commit': ['git_commit', 'skill_commit'],
        'push': ['git_push', 'skill_publish'],
        'pull': ['git_pr_create'],
        'merge': ['git_pr_create'],
        'test': ['test_pass', 'test_fail'],
        'build': ['build_complete', 'build_error'],
        'compile': ['build_complete', 'build_error'],
        'team': ['team_created', 'team_deleted', 'teammate_message'],
        'message': ['teammate_message', 'agent_response'],
        'chat': ['teammate_message'],
        'agent': ['subagent_start', 'subagent_stop'],
        'plan': ['plan_mode_enter', 'plan_mode_exit'],
        'task': ['task_complete', 'long_task'],
        'morning': ['morning'],
        'afternoon': ['afternoon'],
        'evening': ['evening'],
        'night': ['late_night'],
        'streak': ['streak_3', 'streak_5', 'streak_10'],
        'win': ['streak_5', 'test_pass', 'git_push'],
        'victory': ['git_pr_create', 'streak_10'],
        'good': ['tool_success', 'test_pass', 'git_commit'],
        'bad': ['tool_failure', 'test_fail', 'git_error'],
        'lovely': ['background_task_done'],
        'nice': ['tool_success', 'task_complete'],
        'excellent': ['streak_10', 'git_pr_create'],
        'thirsty': ['context_50', 'thinking_medium'],
        'drink': ['afternoon', 'context_50'],
        'coke': ['evening'],
        'story': ['agent_response', 'plan_mode_exit'],
        'options': ['session_end'],
        'bench': ['plan_mode_enter', 'skill_gsd'],
        'shot': ['git_commit', 'test_pass', 'tool_success'],
        'hole': ['test_fail', 'tool_failure'],
        'mad': ['error_threshold', 'git_error'],
        'angry': ['error_threshold'],
    }

    suggestions = {}
    used_events = set()

    # Parse each filename and find matches
    for filename in audio_files:
        # Remove extension and convert to lowercase
        name_lower = Path(filename).stem.lower()

        matches = []
        for keyword, events in FILENAME_PATTERNS.items():
            if keyword in name_lower:
                for event in events:
                    if event not in used_events:
                        # Calculate confidence score
                        confidence = 85
                        if name_lower.startswith(keyword):
                            confidence = 95
                        elif name_lower.endswith(keyword):
                            confidence = 90
                        elif keyword == name_lower:
                            confidence = 100

                        matches.append({
                            'event': event,
                            'confidence': confidence,
                            'keyword': keyword
                        })

        if matches:
            # Sort by confidence and take the best match
            matches.sort(key=lambda x: x['confidence'], reverse=True)
            best_match = matches[0]
            suggestions[filename] = {
                'event': best_match['event'],
                'confidence': best_match['confidence'],
                'keyword': best_match['keyword']
            }
            used_events.add(best_match['event'])

    return jsonify({
        'status': 'success',
        'suggestions': suggestions,
        'matched_count': len(suggestions)
    })

@app.route('/api/claude-suggests', methods=['GET'])
def claude_suggests():
    """Generate smart suggestions for event configuration"""

    # Claude's opinionated recommendations for a balanced sound experience
    suggestions = {
        'events': {
            # Keep core events on with nice sounds
            'session_start': {'enabled': True, 'sound': 'mGREETING.wav'},
            'task_complete': {'enabled': True, 'sound': 'FemalePLSSuccess.wav'},
            'permission': {'enabled': True, 'sound': 'fWAITING0.wav'},

            # Turn off noisy tool events (too frequent)
            'tool_pre': {'enabled': False},
            'tool_success': {'enabled': False},  # Too frequent, gets annoying

            # Keep important failures on
            'tool_failure': {'enabled': True, 'sound': 'fOOPS0.wav'},
            'error_threshold': {'enabled': True, 'sound': 'fMAD0.wav'},

            # Git operations - celebrate the wins
            'git_commit': {'enabled': True, 'sound': 'Good Shot M.wav'},
            'git_push': {'enabled': True, 'sound': 'FemaleSKSSSuccess.wav'},
            'git_pr_create': {'enabled': True, 'sound': 'fCELEB0.wav'},
            'git_error': {'enabled': True, 'sound': 'Bad Shot M.wav'},

            # Testing - important feedback
            'test_pass': {'enabled': True, 'sound': 'Easy Shot FM.wav'},
            'test_fail': {'enabled': True, 'sound': 'fBADHOLE.wav'},

            # Build events
            'build_complete': {'enabled': True, 'sound': 'MalePLSSuccess.wav'},
            'build_error': {'enabled': True, 'sound': 'MalePLSFailure.wav'},

            # Subagents - useful notifications
            'subagent_start': {'enabled': True, 'sound': 'mHAPPY0.wav'},
            'subagent_stop': {'enabled': True, 'sound': 'MaleSSSSuccess.wav'},

            # Teams
            'team_created': {'enabled': True, 'sound': 'FemaleSKSSHappy.wav'},
            'team_deleted': {'enabled': False},  # Less important
            'teammate_message': {'enabled': True, 'sound': 'fHAPPY1.wav'},

            # Plan mode
            'plan_mode_enter': {'enabled': True, 'sound': 'mBENCH0.wav'},
            'plan_mode_exit': {'enabled': True, 'sound': 'mSTORYYES.wav'},

            # Performance warnings
            'long_task': {'enabled': True, 'sound': 'fTIRED.wav'},
            'background_task_done': {'enabled': True, 'sound': 'fLOVELY0.wav'},

            # Thinking depth - disable (too noisy)
            'thinking_short': {'enabled': False},
            'thinking_medium': {'enabled': False},
            'thinking_long': {'enabled': False},

            # Context warnings - important!
            'context_50': {'enabled': False},  # Too early
            'context_75': {'enabled': True, 'sound': 'fHUNGRY.wav'},
            'context_90': {'enabled': True, 'sound': 'fHUNGRY2.wav'},

            # Streaks - fun motivation
            'streak_3': {'enabled': True, 'sound': 'Good Shot FM.wav'},
            'streak_5': {'enabled': True, 'sound': 'Good Shot FM2.wav'},
            'streak_10': {'enabled': True, 'sound': 'fCELEB0.wav'},

            # Time of day - useful awareness
            'morning': {'enabled': True, 'sound': 'mGREETING.wav'},
            'afternoon': {'enabled': False},
            'evening': {'enabled': False},
            'late_night': {'enabled': True, 'sound': 'mTIRED.wav'},  # Reminder to sleep!

            # Skills - celebrate important workflows
            'skill_commit': {'enabled': True, 'sound': 'Good Shot M.wav'},
            'skill_newday': {'enabled': True, 'sound': 'FemalePLSHappy.wav'},
            'skill_publish': {'enabled': True, 'sound': 'FemaleSKSSSuccess.wav'},
            'skill_deploy': {'enabled': True, 'sound': 'MaleSSSSuccess.wav'},
            'skill_gsd': {'enabled': True, 'sound': 'mBENCH0.wav'},

            # Other - keep minimal
            'user_prompt': {'enabled': False},
            'agent_response': {'enabled': False},
            'session_end': {'enabled': True, 'sound': 'mOPTIONS.wav'},
        },
        'reasoning': {
            'philosophy': 'Celebrate wins, warn on problems, avoid noise',
            'disabled_count': 11,
            'focus': 'Keep sounds for meaningful events: completions, errors, achievements, and important milestones',
            'noise_reduction': 'Disabled high-frequency events like tool_success and thinking events to prevent fatigue'
        }
    }

    return jsonify(suggestions)

if __name__ == '__main__':
    print("🔊 Noisy Claude Control Panel Server")
    print(f"📁 Config: {CONFIG_FILE}")
    print(f"🎵 Sounds: {SOUNDS_DIR}")
    print("🌐 Server starting at http://localhost:5050")
    print("\n👉 Open http://localhost:5050 in your browser\n")

    app.run(host='127.0.0.1', port=5050, debug=True)
