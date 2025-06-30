#!/bin/bash

# Vul je naam en e-mail in zoals geregistreerd bij GitHub
git config --global user.name "Gerben Notebomer"
git config --global user.email "g.k.notebomer@.com"  

# Initialiseer repository (wordt overgeslagen als al gedaan)
git init

# Voeg remote toe (doe dit alleen als het nog niet gekoppeld is)
git remote add origin https://github.com/GerbenNotebomer/alss_monitor.git 2> /dev/null

# Voeg alle bestanden toe
git add .

# Commit (slaagt alleen als er iets is gewijzigd)
git commit -m "Eerste commit van ALSS Monitor app" || echo "Niets om te committen"

# Push naar GitHub (alleen eerste keer met -u)
git push -u origin master
