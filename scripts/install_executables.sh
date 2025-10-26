# copy executables to ~/.local/bin
# Assign arguments to variables
echo "💾 Copying to home"

SRC_DIR="home"
DEST_DIR="$HOME/.local"

# Use rsync to copy recursively and show each file
rsync -av --progress "$SOURCE_DIR"/ "$DEST_DIR"/ | while IFS= read -r line; do
    # Echo only files being copied (skip directory summary lines)
    if [[ "$line" != *"sending incremental file list"* ]] && \
       [[ "$line" != *"sent "* ]] && \
       [[ "$line" != *"total size"* ]]; then
        echo "Copied: $line"
    fi
done