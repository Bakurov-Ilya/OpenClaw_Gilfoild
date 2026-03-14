#!/bin/bash
# Voice processing helper for Gilfoyle
# Usage: voice.sh transcribe <input.ogg> [output.txt]
#        voice.sh speak <text> <output.mp3> [voice]

export PATH="$HOME/.local/bin:$PATH"

action="$1"

case "$action" in
  transcribe)
    input="$2"
    output="${3:-/tmp/whisper_output.txt}"
    dir=$(dirname "$output")
    mkdir -p "$dir"
    whisper "$input" --model tiny --language ru --output_format txt --output_dir "$dir" --verbose False 2>/dev/null
    # Whisper saves as <basename>.txt in output_dir
    basename=$(basename "$input" .ogg)
    result_file="$dir/${basename}.txt"
    if [ -f "$result_file" ]; then
      cat "$result_file"
      rm -f "$result_file"
    else
      cat "$output" 2>/dev/null || echo "ERROR: transcription failed"
    fi
    ;;
  speak)
    text="$2"
    output="$3"
    voice="${4:-ru-RU-DmitryNeural}"
    python3 -m edge_tts --voice "$voice" --text "$text" --write-media "$output" 2>/dev/null
    echo "$output"
    ;;
  *)
    echo "Usage: $0 transcribe <input.ogg> [output.txt]"
    echo "       $0 speak <text> <output.mp3> [voice]"
    ;;
esac
