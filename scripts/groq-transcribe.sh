#!/bin/bash
# Groq Whisper transcription helper
# Usage: groq-transcribe.sh <audio_file>
export PATH="$HOME/.local/bin:$PATH"

GROQ_API_KEY="${GROQ_API_KEY:-$(python3 -c "import json; d=json.load(open('$HOME/.openclaw/openclaw.json')); print(d.get('env',{}).get('GROQ_API_KEY',''))" 2>/dev/null)}"

INPUT="$1"
if [ -z "$INPUT" ]; then
  echo "Usage: $0 <audio_file>"
  exit 1
fi

# Convert to wav for Groq
TMPWAV="/tmp/groq_$(basename "$INPUT" | sed 's/\.[^.]*$//').wav"
ffmpeg -y -i "$INPUT" -ar 16000 -ac 1 "$TMPWAV" 2>/dev/null

# Transcribe via Groq
RESULT=$(curl -s https://api.groq.com/openai/v1/audio/transcriptions \
  -H "Authorization: Bearer $GROQ_API_KEY" \
  -F "file=@$TMPWAV" \
  -F "model=whisper-large-v3-turbo" \
  -F "language=ru")

rm -f "$TMPWAV"

echo "$RESULT" | python3 -c "
import json, sys
d = json.load(sys.stdin)
if 'text' in d:
    print(d['text'])
else:
    print('ERROR:', d, file=sys.stderr)
    exit(1)
"
