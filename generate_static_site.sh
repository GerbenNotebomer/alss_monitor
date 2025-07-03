#!/bin/bash

# Pad naar README.md
README=README.md
# Map met Dart doc HTML output
DARTDOC_DIR=doc/api
# Output map voor de site
SITE_DIR=site

# Check of pandoc is geïnstalleerd
if ! command -v pandoc &> /dev/null
then
    echo "Pandoc is niet geïnstalleerd. Probeer 'sudo apt install pandoc' of installeer het via je package manager."
    echo "Maak een eenvoudige index.html van README.md handmatig of installeer pandoc."
    exit 1
fi

# Maak output dir schoon en opnieuw aan
rm -rf "$SITE_DIR"
mkdir -p "$SITE_DIR"

# Zet README.md om naar index.html
pandoc "$README" -o "$SITE_DIR/index.html"

# Voeg link naar API docs toe onderaan index.html
echo '<hr><p><a href="api/index.html" target="_blank">Bekijk API documentatie</a></p>' >> "$SITE_DIR/index.html"

# Kopieer dart doc html naar site/api
mkdir -p "$SITE_DIR/api"
cp -r "$DARTDOC_DIR"/* "$SITE_DIR/api"

echo "Site gegenereerd in map '$SITE_DIR'."
echo "Je kunt nu de map 'site' uploaden naar je ESP32 of andere webserver."
