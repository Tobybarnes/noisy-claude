#!/usr/bin/env bash
# mgs-sound-tool.sh — Interactive MGS sound mapping toolkit
# Plays, analyzes, tags, and maps MGS sounds for noisy-claude events
set -euo pipefail

NOISY_CLAUDE_DIR="${NOISY_CLAUDE_DIR:-$HOME/.noisy-claude}"
MGS_DIR="$NOISY_CLAUDE_DIR/sounds/MGS"
CONFIG_FILE="$NOISY_CLAUDE_DIR/config.json"
TAGS_FILE="$NOISY_CLAUDE_DIR/.state/mgs-tags.json"
ANALYSIS_FILE="$NOISY_CLAUDE_DIR/.state/mgs-analysis.json"

mkdir -p "$NOISY_CLAUDE_DIR/.state"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

usage() {
    echo -e "${BOLD}MGS Sound Mapping Tool${NC}"
    echo ""
    echo "Commands:"
    echo "  analyze              Generate audio analysis report (duration, size, sample rate)"
    echo "  listen [filter]      Play sounds interactively, optionally filtered (short/medium/long/all)"
    echo "  listen-dir <dir>     Play sounds from a sample subdirectory"
    echo "  play <file>          Play a single sound file"
    echo "  tag <file> <tag>     Tag a sound with a category (alert/success/fail/ambient/ui/codec/effect)"
    echo "  tags                 Show all tagged sounds"
    echo "  events               List all noisy-claude events and current mappings"
    echo "  map <event> <file>   Map a sound file to a noisy-claude event"
    echo "  apply                Apply all pending mappings to config.json"
    echo "  test <event>         Test a mapped event by playing its sound"
    echo "  batch-play <files..> Play multiple files in sequence"
    echo "  report               Show mapping coverage report"
    echo "  suggest              Auto-suggest mappings based on tags and characteristics"
    echo "  dirs                 List available sample subdirectories"
    echo ""
    echo "Examples:"
    echo "  $0 analyze"
    echo "  $0 listen short"
    echo "  $0 listen-dir sample00"
    echo "  $0 play 0x01.wav"
    echo "  $0 tag 0x01.wav codec"
    echo "  $0 map session_start 0x01.wav"
    echo "  $0 apply"
    echo "  $0 test session_start"
}

# Initialize tags file if missing
init_tags() {
    if [ ! -f "$TAGS_FILE" ]; then
        echo '{}' > "$TAGS_FILE"
    fi
}

# Analyze all MGS sounds
cmd_analyze() {
    echo -e "${BOLD}Analyzing MGS sound library...${NC}"
    python3 -c "
import subprocess, os, json

mgs_dir = '$MGS_DIR'
results = []

# Root-level sounds
for f in sorted(os.listdir(mgs_dir)):
    fpath = os.path.join(mgs_dir, f)
    if f.endswith('.wav') and os.path.isfile(fpath):
        size = os.path.getsize(fpath)
        try:
            out = subprocess.check_output(['afinfo', fpath], text=True, stderr=subprocess.DEVNULL)
            duration = 0
            sample_rate = 'unknown'
            for line in out.split('\n'):
                if 'estimated duration' in line:
                    duration = float(line.split(':')[1].strip().replace(' sec',''))
                if 'Data format' in line:
                    sample_rate = line.split(':')[1].strip()
            results.append({
                'file': f, 'dir': '', 'size': size,
                'duration': round(duration, 3), 'format': sample_rate
            })
        except:
            results.append({'file': f, 'dir': '', 'size': size, 'duration': 0, 'format': 'unknown'})

# Sample subdirectories
for d in sorted(os.listdir(mgs_dir)):
    dpath = os.path.join(mgs_dir, d)
    if os.path.isdir(dpath) and d.startswith('sample'):
        for f in sorted(os.listdir(dpath)):
            fpath = os.path.join(dpath, f)
            if f.endswith('.wav') and os.path.isfile(fpath):
                size = os.path.getsize(fpath)
                try:
                    out = subprocess.check_output(['afinfo', fpath], text=True, stderr=subprocess.DEVNULL)
                    duration = 0
                    sample_rate = 'unknown'
                    for line in out.split('\n'):
                        if 'estimated duration' in line:
                            duration = float(line.split(':')[1].strip().replace(' sec',''))
                        if 'Data format' in line:
                            sample_rate = line.split(':')[1].strip()
                    results.append({
                        'file': f, 'dir': d, 'size': size,
                        'duration': round(duration, 3), 'format': sample_rate
                    })
                except:
                    results.append({'file': f, 'dir': d, 'size': size, 'duration': 0, 'format': 'unknown'})

# Save full analysis
with open('$ANALYSIS_FILE', 'w') as fp:
    json.dump(results, fp, indent=2)

# Print summary
root_sounds = [r for r in results if not r['dir']]
sub_sounds = [r for r in results if r['dir']]
short = [r for r in root_sounds if r['duration'] < 1]
medium = [r for r in root_sounds if 1 <= r['duration'] < 3]
long = [r for r in root_sounds if r['duration'] >= 3]

print(f'Root-level sounds: {len(root_sounds)}')
print(f'  Short (<1s):   {len(short)}')
print(f'  Medium (1-3s): {len(medium)}')
print(f'  Long (3s+):    {len(long)}')
print(f'')
dirs = set(r['dir'] for r in sub_sounds)
print(f'Sample directories: {len(dirs)}')
print(f'Sounds in subdirs:  {len(sub_sounds)}')
print(f'Total sounds:       {len(results)}')
print(f'')
print(f'Analysis saved to: $ANALYSIS_FILE')
"
}

# Interactive listen mode
cmd_listen() {
    local filter="${1:-all}"
    echo -e "${BOLD}Interactive Listen Mode${NC} (filter: $filter)"
    echo -e "${DIM}Controls: [Enter]=next  [r]=replay  [t]=tag  [m]=map  [s]=skip 10  [q]=quit${NC}"
    echo ""

    # Get filtered file list
    local files
    files=$(python3 -c "
import subprocess, os

mgs_dir = '$MGS_DIR'
filt = '$filter'
results = []

for f in sorted(os.listdir(mgs_dir)):
    fpath = os.path.join(mgs_dir, f)
    if not f.endswith('.wav') or not os.path.isfile(fpath):
        continue
    try:
        out = subprocess.check_output(['afinfo', fpath], text=True, stderr=subprocess.DEVNULL)
        duration = 0
        for line in out.split('\n'):
            if 'estimated duration' in line:
                duration = float(line.split(':')[1].strip().replace(' sec',''))
    except:
        duration = 0

    if filt == 'all':
        results.append(f'{f}|{duration:.2f}')
    elif filt == 'short' and duration < 1:
        results.append(f'{f}|{duration:.2f}')
    elif filt == 'medium' and 1 <= duration < 3:
        results.append(f'{f}|{duration:.2f}')
    elif filt == 'long' and duration >= 3:
        results.append(f'{f}|{duration:.2f}')

for r in results:
    print(r)
")

    local total
    total=$(echo "$files" | wc -l | tr -d ' ')
    local idx=0

    while IFS='|' read -r fname duration; do
        idx=$((idx + 1))
        echo -e "${CYAN}[$idx/$total]${NC} ${BOLD}$fname${NC} ${DIM}(${duration}s)${NC}"

        # Check if tagged
        local tag
        tag=$(python3 -c "
import json
try:
    with open('$TAGS_FILE') as f: tags = json.load(f)
    t = tags.get('$fname', {}).get('tag', '')
    if t: print(f'  Tagged: {t}')
except: pass
" 2>/dev/null) || true
        [ -n "$tag" ] && echo -e "${GREEN}$tag${NC}"

        afplay "$MGS_DIR/$fname" &
        local pid=$!

        while true; do
            echo -ne "${DIM}> ${NC}"
            read -rsn1 key
            echo ""

            case "$key" in
                ""|"n")
                    kill $pid 2>/dev/null || true
                    wait $pid 2>/dev/null || true
                    break
                    ;;
                "r")
                    kill $pid 2>/dev/null || true
                    wait $pid 2>/dev/null || true
                    echo -e "${DIM}  replaying...${NC}"
                    afplay "$MGS_DIR/$fname" &
                    pid=$!
                    ;;
                "t")
                    kill $pid 2>/dev/null || true
                    wait $pid 2>/dev/null || true
                    echo -ne "  Tag (alert/success/fail/ambient/ui/codec/effect/skip): "
                    read -r tag_input
                    if [ -n "$tag_input" ] && [ "$tag_input" != "skip" ]; then
                        cmd_tag "$fname" "$tag_input"
                    fi
                    break
                    ;;
                "m")
                    kill $pid 2>/dev/null || true
                    wait $pid 2>/dev/null || true
                    echo -ne "  Event name: "
                    read -r event_input
                    if [ -n "$event_input" ]; then
                        cmd_map "$event_input" "$fname"
                    fi
                    break
                    ;;
                "s")
                    kill $pid 2>/dev/null || true
                    wait $pid 2>/dev/null || true
                    echo -e "${DIM}  skipping 10...${NC}"
                    # Skip ahead by reading and discarding 9 more lines
                    for i in $(seq 1 9); do
                        read -r _ || break
                        idx=$((idx + 1))
                    done
                    break
                    ;;
                "q")
                    kill $pid 2>/dev/null || true
                    wait $pid 2>/dev/null || true
                    echo -e "${YELLOW}Quit.${NC}"
                    return 0
                    ;;
            esac
        done
    done <<< "$files"

    echo -e "${GREEN}Done! Listened to all $total sounds.${NC}"
}

# Listen to sounds in a subdirectory
cmd_listen_dir() {
    local dir="${1:?Usage: mgs-sound-tool.sh listen-dir <dirname>}"
    local dirpath="$MGS_DIR/$dir"

    if [ ! -d "$dirpath" ]; then
        echo -e "${RED}Directory not found: $dir${NC}"
        echo "Use 'dirs' to list available directories."
        exit 1
    fi

    echo -e "${BOLD}Listening to $dir${NC}"
    echo -e "${DIM}Controls: [Enter]=next  [r]=replay  [t]=tag  [q]=quit${NC}"
    echo ""

    local files
    files=$(ls "$dirpath"/*.wav 2>/dev/null | sort) || { echo "No wav files found."; exit 1; }
    local total
    total=$(echo "$files" | wc -l | tr -d ' ')
    local idx=0

    while IFS= read -r fpath; do
        idx=$((idx + 1))
        local fname
        fname=$(basename "$fpath")
        local relname="$dir/$fname"

        local duration
        duration=$(afinfo "$fpath" 2>/dev/null | grep "estimated duration" | awk '{print $3}' || echo "?")

        echo -e "${CYAN}[$idx/$total]${NC} ${BOLD}$relname${NC} ${DIM}(${duration}s)${NC}"

        afplay "$fpath" &
        local pid=$!

        while true; do
            echo -ne "${DIM}> ${NC}"
            read -rsn1 key
            echo ""

            case "$key" in
                ""|"n")
                    kill $pid 2>/dev/null || true
                    wait $pid 2>/dev/null || true
                    break
                    ;;
                "r")
                    kill $pid 2>/dev/null || true
                    wait $pid 2>/dev/null || true
                    afplay "$fpath" &
                    pid=$!
                    ;;
                "t")
                    kill $pid 2>/dev/null || true
                    wait $pid 2>/dev/null || true
                    echo -ne "  Tag (alert/success/fail/ambient/ui/codec/effect/skip): "
                    read -r tag_input
                    if [ -n "$tag_input" ] && [ "$tag_input" != "skip" ]; then
                        cmd_tag "$relname" "$tag_input"
                    fi
                    break
                    ;;
                "q")
                    kill $pid 2>/dev/null || true
                    wait $pid 2>/dev/null || true
                    echo -e "${YELLOW}Quit.${NC}"
                    return 0
                    ;;
            esac
        done
    done <<< "$files"
}

# Play a single sound
cmd_play() {
    local file="${1:?Usage: mgs-sound-tool.sh play <file>}"

    # Check both root and subdirectories
    if [ -f "$MGS_DIR/$file" ]; then
        local duration
        duration=$(afinfo "$MGS_DIR/$file" 2>/dev/null | grep "estimated duration" | awk '{print $3}' || echo "?")
        echo -e "Playing ${BOLD}$file${NC} ${DIM}(${duration}s)${NC}"
        afplay "$MGS_DIR/$file"
    else
        echo -e "${RED}File not found: $file${NC}"
        exit 1
    fi
}

# Tag a sound
cmd_tag() {
    local file="${1:?Usage: mgs-sound-tool.sh tag <file> <tag>}"
    local tag="${2:?Provide a tag: alert/success/fail/ambient/ui/codec/effect}"

    init_tags
    python3 -c "
import json
with open('$TAGS_FILE') as f: tags = json.load(f)
tags['$file'] = {'tag': '$tag'}
with open('$TAGS_FILE', 'w') as f: json.dump(tags, f, indent=2); f.write('\n')
print('Tagged $file as $tag')
"
}

# Show all tags
cmd_tags() {
    init_tags
    python3 -c "
import json
with open('$TAGS_FILE') as f: tags = json.load(f)
if not tags:
    print('No tags yet. Use: mgs-sound-tool.sh tag <file> <category>')
    exit()

by_tag = {}
for fname, info in sorted(tags.items()):
    t = info.get('tag', 'untagged')
    by_tag.setdefault(t, []).append(fname)

for tag in sorted(by_tag):
    print(f'\n{tag.upper()} ({len(by_tag[tag])}):')
    for f in sorted(by_tag[tag]):
        print(f'  {f}')
print(f'\nTotal tagged: {len(tags)}')
"
}

# List events
cmd_events() {
    python3 -c "
import json
with open('$CONFIG_FILE') as f: config = json.load(f)
events = config.get('events', {})

print('Noisy Claude Events and Current MGS Mappings:')
print('')
for name in sorted(events):
    e = events[name]
    enabled = 'ON ' if e.get('enabled') else 'OFF'
    sound = e.get('sound', 'none')
    desc = e.get('description', '')
    print(f'  [{enabled}] {name:25} -> {sound:25} # {desc}')
print(f'\nTotal events: {len(events)}')
"
}

# Map a sound to an event (staged, not yet applied)
cmd_map() {
    local event="${1:?Usage: mgs-sound-tool.sh map <event> <file>}"
    local file="${2:?Provide a sound file}"

    local mappings_file="$NOISY_CLAUDE_DIR/.state/mgs-mappings.json"

    python3 -c "
import json, os

mappings_file = '$mappings_file'
if os.path.exists(mappings_file):
    with open(mappings_file) as f: mappings = json.load(f)
else:
    mappings = {}

mappings['$event'] = '$file'
with open(mappings_file, 'w') as f: json.dump(mappings, f, indent=2); f.write('\n')
print('Staged mapping: $event -> $file')
print(f'Total staged mappings: {len(mappings)}')
print('Run \"apply\" to write mappings to config.json')
"
}

# Apply staged mappings to config.json
cmd_apply() {
    local mappings_file="$NOISY_CLAUDE_DIR/.state/mgs-mappings.json"

    if [ ! -f "$mappings_file" ]; then
        echo -e "${RED}No staged mappings found. Use 'map' to create mappings first.${NC}"
        exit 1
    fi

    python3 -c "
import json, shutil

# Backup config
shutil.copy('$CONFIG_FILE', '$CONFIG_FILE.bak')

with open('$CONFIG_FILE') as f: config = json.load(f)
with open('$mappings_file') as f: mappings = json.load(f)

events = config.get('events', {})
applied = 0
skipped = 0

for event, sound in mappings.items():
    if event in events:
        old = events[event].get('sound', 'none')
        events[event]['sound'] = sound
        print(f'  Applied: {event} -> {sound} (was: {old})')
        applied += 1
    else:
        print(f'  Skipped: {event} (not a valid event)')
        skipped += 1

config['events'] = events
with open('$CONFIG_FILE', 'w') as f:
    json.dump(config, f, indent=2)
    f.write('\n')

print(f'')
print(f'Applied: {applied} mappings')
if skipped:
    print(f'Skipped: {skipped} (invalid events)')
print(f'Backup saved: $CONFIG_FILE.bak')
"
}

# Test an event's mapped sound
cmd_test() {
    local event="${1:?Usage: mgs-sound-tool.sh test <event>}"

    local sound_file
    sound_file=$(python3 -c "
import json
with open('$CONFIG_FILE') as f: config = json.load(f)
event = config.get('events', {}).get('$event', {})
sound = event.get('sound', '')
active = config.get('active_collection', 'default')
collections = config.get('collections', {})
if active in collections:
    path = collections[active]['path']
else:
    path = '$MGS_DIR'
if sound:
    print(f'{path}/{sound}')
") || true

    if [ -z "$sound_file" ] || [ ! -f "$sound_file" ]; then
        echo -e "${RED}No sound mapped for event: $event${NC}"
        exit 1
    fi

    echo -e "Testing ${BOLD}$event${NC} -> $(basename "$sound_file")"
    afplay "$sound_file"
}

# Mapping coverage report
cmd_report() {
    python3 -c "
import json, os

with open('$CONFIG_FILE') as f: config = json.load(f)
events = config.get('events', {})

active = config.get('active_collection', 'default')
collections = config.get('collections', {})
if active in collections:
    sounds_path = collections[active]['path']
else:
    sounds_path = '$MGS_DIR'

# Check which sounds actually exist
available = set()
if os.path.isdir(sounds_path):
    for f in os.listdir(sounds_path):
        if f.endswith(('.wav', '.mp3', '.aiff', '.m4a')):
            available.add(f)

mapped = set()
unmapped = []
missing = []
enabled_count = 0

for name, e in sorted(events.items()):
    sound = e.get('sound', '')
    enabled = e.get('enabled', False)
    if enabled:
        enabled_count += 1
    if sound:
        mapped.add(sound)
        if sound not in available:
            missing.append((name, sound))
    else:
        unmapped.append(name)

unused = available - mapped

print(f'Collection: {active} ({sounds_path})')
print(f'Available sounds: {len(available)}')
print(f'')
print(f'Events: {len(events)} total, {enabled_count} enabled')
print(f'Mapped:   {len(events) - len(unmapped)} events have sounds assigned')
print(f'Unmapped: {len(unmapped)} events need sounds')
print(f'')

if missing:
    print('MISSING SOUNDS (mapped but file not found):')
    for name, sound in missing:
        print(f'  {name:25} -> {sound}')
    print()

if unmapped:
    print('UNMAPPED EVENTS (no sound assigned):')
    for name in unmapped:
        print(f'  {name}')
    print()

if unused:
    print(f'UNUSED SOUNDS ({len(unused)} sounds not mapped to any event):')
    for s in sorted(unused):
        print(f'  {s}')
"
}

# List sample directories
cmd_dirs() {
    echo -e "${BOLD}Sample Directories:${NC}"
    for d in "$MGS_DIR"/sample*/; do
        if [ -d "$d" ]; then
            local dname
            dname=$(basename "$d")
            local count
            count=$(ls "$d"/*.wav 2>/dev/null | wc -l | tr -d ' ')
            echo -e "  ${CYAN}$dname${NC}  ($count wav files)"
        fi
    done
}

# Auto-suggest mappings based on audio characteristics
cmd_suggest() {
    init_tags
    echo -e "${BOLD}Auto-suggesting mappings based on audio characteristics...${NC}"
    echo ""

    python3 -c "
import json, os, subprocess

with open('$CONFIG_FILE') as f: config = json.load(f)
events = config.get('events', {})

try:
    with open('$TAGS_FILE') as f: tags = json.load(f)
except:
    tags = {}

mgs_dir = '$MGS_DIR'

# Analyze root sounds
sounds = {}
for f in sorted(os.listdir(mgs_dir)):
    fpath = os.path.join(mgs_dir, f)
    if not f.endswith('.wav') or not os.path.isfile(fpath):
        continue
    try:
        out = subprocess.check_output(['afinfo', fpath], text=True, stderr=subprocess.DEVNULL)
        duration = 0
        for line in out.split('\n'):
            if 'estimated duration' in line:
                duration = float(line.split(':')[1].strip().replace(' sec',''))
        size = os.path.getsize(fpath)
        tag = tags.get(f, {}).get('tag', '')
        sounds[f] = {'duration': duration, 'size': size, 'tag': tag}
    except:
        pass

# Categorize by duration
short = {k: v for k, v in sounds.items() if v['duration'] < 0.5}
medium_short = {k: v for k, v in sounds.items() if 0.5 <= v['duration'] < 1.0}
medium = {k: v for k, v in sounds.items() if 1.0 <= v['duration'] < 2.0}
long = {k: v for k, v in sounds.items() if v['duration'] >= 2.0}

# Suggest mappings based on sound characteristics
suggestions = {}

# Short blips: good for frequent events
short_list = sorted(short.keys())
medium_short_list = sorted(medium_short.keys())
medium_list = sorted(medium.keys())
long_list = sorted(long.keys())

# Strategy: Short sounds for frequent events, longer for milestones
# Use tagged sounds preferentially
def pick(pool, tag_pref=None, idx=[0]):
    if tag_pref:
        tagged = [s for s in pool if sounds.get(s,{}).get('tag') == tag_pref]
        if tagged:
            return tagged[0]
    if pool:
        choice = pool[idx[0] % len(pool)]
        idx[0] += 1
        return choice
    return None

print('Suggested mappings (based on duration/characteristics):')
print('')
print('SHORT SOUNDS (<0.5s) - for frequent/UI events:')
for s in sorted(short.keys())[:10]:
    print(f'  {s:12} {short[s][\"duration\"]:.2f}s')

print('')
print('MEDIUM-SHORT (0.5-1s) - for tool results/notifications:')
for s in sorted(medium_short.keys())[:10]:
    print(f'  {s:12} {medium_short[s][\"duration\"]:.2f}s')

print('')
print('MEDIUM (1-2s) - for task events/git operations:')
for s in sorted(medium.keys())[:10]:
    print(f'  {s:12} {medium[s][\"duration\"]:.2f}s')

print('')
print('LONG (2s+) - for milestones/session events:')
for s in sorted(long.keys()):
    print(f'  {s:12} {long[s][\"duration\"]:.2f}s')

print('')
print('Use \"listen short\", \"listen medium\", \"listen long\" to audition each category.')
print('Use \"tag\" and \"map\" to assign sounds to events.')
"
}

# Batch play
cmd_batch_play() {
    local files=("${@}")
    if [ ${#files[@]} -eq 0 ]; then
        echo "Usage: mgs-sound-tool.sh batch-play <file1> [file2] ..."
        exit 1
    fi

    for f in "${files[@]}"; do
        if [ -f "$MGS_DIR/$f" ]; then
            echo -e "Playing ${BOLD}$f${NC}"
            afplay "$MGS_DIR/$f"
            sleep 0.3
        else
            echo -e "${RED}Not found: $f${NC}"
        fi
    done
}

# Main command router
case "${1:-help}" in
    analyze)    cmd_analyze ;;
    listen)     cmd_listen "${2:-all}" ;;
    listen-dir) cmd_listen_dir "${2:-}" ;;
    play)       cmd_play "${2:-}" ;;
    tag)        cmd_tag "${2:-}" "${3:-}" ;;
    tags)       cmd_tags ;;
    events)     cmd_events ;;
    map)        cmd_map "${2:-}" "${3:-}" ;;
    apply)      cmd_apply ;;
    test)       cmd_test "${2:-}" ;;
    report)     cmd_report ;;
    suggest)    cmd_suggest ;;
    dirs)       cmd_dirs ;;
    batch-play) shift; cmd_batch_play "$@" ;;
    help|--help|-h) usage ;;
    *)          echo "Unknown command: $1"; usage; exit 1 ;;
esac
