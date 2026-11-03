#!/bin/bash
#
# make-public.sh
# Setzt in SwiftUI-Views "public" vor struct/enum/extension-Members
# in einem BasiliskUI-Package — vorsichtig und idempotent.
#
# Verwendung:
#   ./make-public.sh                       # Dry-Run im aktuellen Verzeichnis
#   ./make-public.sh --apply               # Änderungen schreiben
#   ./make-public.sh Sources/Navigation    # Nur ein Unterverzeichnis
#

set -euo pipefail

APPLY=false
TARGET_DIR="Sources"

while [[ $# -gt 0 ]]; do
    case "$1" in
        --apply) APPLY=true; shift ;;
        -h|--help)
            grep '^#' "$0" | sed 's/^# \{0,1\}//'
            exit 0
            ;;
        *) TARGET_DIR="$1"; shift ;;
    esac
done

if [[ ! -d "$TARGET_DIR" ]]; then
    echo "❌ Verzeichnis '$TARGET_DIR' nicht gefunden."
    exit 1
fi

echo "🐍 Scanne '$TARGET_DIR' …"
echo "   Modus: $([ "$APPLY" = true ] && echo "APPLY (schreibt)" || echo "DRY-RUN (zeigt nur)")"
echo ""

# Nur Swift-Dateien, rekursiv
FILES=()
while IFS= read -r -d '' file; do
    FILES+=("$file")
done < <(find "$TARGET_DIR" -name "*.swift" -type f -print0)

if [[ ${#FILES[@]} -eq 0 ]]; then
    echo "Keine .swift-Dateien gefunden."
    exit 0
fi

CHANGED=0

for file in "${FILES[@]}"; do
    # Skip: Package.swift, Preview-Dateien, Test-Dateien
    if [[ "$file" == *"Package.swift"* ]] \
       || [[ "$file" == *"Preview"* ]] \
       || [[ "$file" == *"Tests"* ]]; then
        continue
    fi

    original=$(<"$file")
    modified="$original"

    # ── 1. struct/enum/class/protocol am Anfang einer Zeile
    #      public struct Foo: View {   ← wenn nicht schon public
    modified=$(echo "$modified" | perl -pe '
        s/^(\s*)(struct|enum|class|protocol)(\s+\w+)/$1public $2$3/
          unless /^\s*(\/\/|public|private|fileprivate|internal|final\s+public)/;
    ')

    # ── 2. Members: let/var/func/init in einem public-Body.
    #      Vorsichtige Heuristik: nur 4-Space-Einrückung, nur bei bekannten
    #      public-View-Dateien. Wir machen das pro Datei, wenn die Datei
    #      "public struct" oder "public enum" enthält.
    if echo "$modified" | grep -q '^public \(struct\|enum\|class\)'; then
        # 4-Space eingerückte let/var/func
        modified=$(echo "$modified" | perl -pe '
            s/^(\s{4})(let|var|func|init)\b/$1public $2/
              unless /^\s{4}(\/\/|public|private|fileprivate|internal|@|\})/;
        ')
        # 4-Space eingerückte static let/var/func
        modified=$(echo "$modified" | perl -pe '
            s/^(\s{4})(static\s+(?:let|var|func))\b/$1public $2/
              unless /^\s{4}(\/\/|public|private|fileprivate|internal)/;
        ')
    fi

    if [[ "$modified" != "$original" ]]; then
        CHANGED=$((CHANGED + 1))
        echo "📝 $file"

        if [[ "$APPLY" = true ]]; then
            # Backup
            cp "$file" "$file.bak"
            printf '%s\n' "$modified" > "$file"
            echo "   ✅ geschrieben (Backup: $file.bak)"
        fi
    fi
done

echo ""
echo "─── Zusammenfassung ───"
echo "Dateien mit Änderungen: $CHANGED"
if [[ "$APPLY" = false && $CHANGED -gt 0 ]]; then
    echo ""
    echo "Das war ein DRY-RUN. Ausführen mit:"
    echo "  $0 --apply $TARGET_DIR"
fi