#!/usr/bin/env bash
#
# build.sh -- checks for / installs the Jupyter Book (MyST) CLI, then builds
# this book into a static HTML site under _build/html, and serves it locally.
#
# Usage:
#   ./build.sh              build the static site AND serve it locally
#   ./build.sh build-only   build the static site, do not start a server
#   ./build.sh serve        start myst's live-reloading dev/preview server
#   ./build.sh clean        remove build artifacts
#
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info()  { echo -e "${GREEN}==>${NC} $1"; }
warn()  { echo -e "${YELLOW}==>${NC} $1"; }
error() { echo -e "${RED}==>${NC} $1" >&2; }

# ---------------------------------------------------------------------------
# 1. Make sure we have a Python + pip to install the `myst` CLI with.
# ---------------------------------------------------------------------------
PYTHON_BIN=""
for candidate in python3 python; do
    if command -v "$candidate" >/dev/null 2>&1; then
        PYTHON_BIN="$candidate"
        break
    fi
done

if [ -z "$PYTHON_BIN" ]; then
    error "Python 3 is required but was not found on PATH."
    error "Install Python 3 (https://www.python.org/downloads/) and re-run this script."
    exit 1
fi
info "Using Python: $($PYTHON_BIN --version)"

PIP_INSTALL_FLAGS=""
if $PYTHON_BIN -m pip install --help 2>/dev/null | grep -q "break-system-packages"; then
    PIP_INSTALL_FLAGS="--break-system-packages"
fi

# ---------------------------------------------------------------------------
# 2. Check for the `myst` CLI (Jupyter Book / MyST Document Engine).
#    It ships as a pure-Python wheel (mystmd-py) so `pip install mystmd`
#    is normally all that's needed -- no separate Node.js install required.
# ---------------------------------------------------------------------------
if command -v myst >/dev/null 2>&1; then
    info "Found existing myst CLI: $(myst --version 2>/dev/null || echo 'version unknown')"
else
    warn "myst CLI not found. Installing via pip (package: mystmd)..."
    if ! $PYTHON_BIN -m pip install --user $PIP_INSTALL_FLAGS mystmd; then
        error "pip install mystmd failed."
        error "If this environment has Node.js/npm instead, you can alternatively run:"
        error "    npm install -g mystmd"
        exit 1
    fi

    # Make sure the user-site bin directory is on PATH for this session.
    USER_BASE="$($PYTHON_BIN -m site --user-base 2>/dev/null || true)"
    if [ -n "$USER_BASE" ] && [ -d "$USER_BASE/bin" ]; then
        export PATH="$USER_BASE/bin:$PATH"
    fi

    if ! command -v myst >/dev/null 2>&1; then
        error "myst was installed but is not on PATH."
        error "Add your Python user-site bin directory to PATH and re-run, e.g.:"
        error "    export PATH=\"\$($PYTHON_BIN -m site --user-base)/bin:\$PATH\""
        exit 1
    fi
    info "Installed myst CLI: $(myst --version 2>/dev/null || echo 'version unknown')"
fi

# ---------------------------------------------------------------------------
# 3. Handle subcommands.
# ---------------------------------------------------------------------------
ACTION="${1:-build}"

case "$ACTION" in
    clean)
        info "Removing _build/ ..."
        rm -rf _build
        info "Clean."
        ;;
    serve)
        info "Starting MyST live preview server (Ctrl+C to stop)..."
        myst start
        ;;
    build-only)
        info "Building static HTML site..."
        myst build --html --ci
        if [ ! -f "_build/html/index.html" ]; then
            error "Build finished but _build/html/index.html is missing -- something went wrong upstream."
            exit 1
        fi
        info "Done. Static site written to: $(pwd)/_build/html"
        ;;
    build|"")
        info "Building static HTML site..."
        myst build --html --ci
        echo

        if [ ! -f "_build/html/index.html" ]; then
            error "Build finished but _build/html/index.html is missing -- something went wrong upstream."
            exit 1
        fi
        info "Static site written to: $(pwd)/_build/html"

        # Pick a free port starting at 8000, so re-runs don't collide with a
        # server left over from a previous run (a common cause of
        # "Unable to connect" -- the port was already taken, not actually free).
        PORT=8000
        while $PYTHON_BIN -c "
import socket, sys
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
sys.exit(0 if s.connect_ex(('127.0.0.1', $PORT)) == 0 else 1)
" 2>/dev/null; do
            PORT=$((PORT + 1))
        done

        info "Starting a local preview server on http://127.0.0.1:${PORT} (Ctrl+C to stop)"
        echo "    (binding to 127.0.0.1 explicitly -- if you're on a remote box/VM/container,"
        echo "     use 'http://localhost:${PORT}' from a browser on the SAME machine, or set up"
        echo "     port forwarding, e.g. 'ssh -L ${PORT}:localhost:${PORT} user@host')"
        echo
        cd _build/html
        exec $PYTHON_BIN -m http.server "$PORT" --bind 127.0.0.1
        ;;
    *)
        error "Unknown action: $ACTION"
        error "Usage: $0 [build|build-only|serve|clean]"
        exit 1
        ;;
esac
