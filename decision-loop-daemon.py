#!/usr/bin/env python3
"""Daemonized decision loop for Noisy Claude."""
import sys, os, json, subprocess, time

pid_file = sys.argv[1]
config_file = sys.argv[2]

with open(config_file) as f:
    config = json.load(f)

active = config.get('active_collection', 'default')
collections = config.get('collections', {})

if active in collections and 'events' in collections[active]:
    event = collections[active]['events'].get('decision_waiting', {})
else:
    event = config.get('events', {}).get('decision_waiting', {})

if not event.get('enabled', False):
    sys.exit(0)

if active in collections:
    sounds_path = collections[active]['path']
else:
    sounds_path = os.path.join(os.path.dirname(config_file), 'sounds')

sound_file = event.get('sound', '')
sound_path = os.path.join(sounds_path, sound_file)

if not sound_file or not os.path.exists(sound_path):
    sys.exit(0)

volume = str(config.get('volume', 100) / 100.0)

# Double-fork to fully daemonize
pid = os.fork()
if pid > 0:
    sys.exit(0)

os.setsid()

pid = os.fork()
if pid > 0:
    sys.exit(0)

# Daemon process — write PID
with open(pid_file, 'w') as f:
    f.write(str(os.getpid()))

# Loop: play, wait 15s, check PID file still points to us
while True:
    try:
        with open(pid_file) as f:
            if f.read().strip() != str(os.getpid()):
                break
    except (FileNotFoundError, ValueError):
        break

    subprocess.run(['afplay', '-v', volume, sound_path],
                   capture_output=True, timeout=30)

    for _ in range(15):
        time.sleep(1)
        try:
            with open(pid_file) as f:
                if f.read().strip() != str(os.getpid()):
                    sys.exit(0)
        except (FileNotFoundError, ValueError):
            sys.exit(0)
