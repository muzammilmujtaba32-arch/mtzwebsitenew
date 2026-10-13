#!/bin/bash
# Preview the website locally at http://127.0.0.1:8737  (press Ctrl+C to stop)
cd "$(dirname "$0")/../site" && exec python3 -m http.server 8737 --bind 127.0.0.1
