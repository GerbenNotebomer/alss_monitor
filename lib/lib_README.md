
# lib Folder - ALSS_APP_V2.1_ONT

Deze folder bevat de kern van de Flutter-applicatie, inclusief alle modellen, schermen, navigatie, services en widgets.

## Structuur

- **config/**  
  Bevat configuratiebestanden zoals app-instellingen en documentatie over configuraties.

- **models/**  
  Definieert de data modellen die gebruikt worden in de app, zoals `Channel` en `DataModel`.

- **navigation/**  
  Bevat navigatiecomponenten en widgets, zoals de hoofdnavigatie en app drawer.

- **screens/**  
  Verschillende schermen van de app, bijvoorbeeld dashboard, meters, instellingen en raw JSON weergave.

- **services/**  
  Diensten voor data-ophaallogica en vertalingen. Hier vindt ook communicatie met backend of data repositories plaats.

- **widgets/**  
  Herbruikbare widgets die in verschillende schermen gebruikt worden, zoals cards, filters en basispagina componenten.

## Gebruik

De `lib` folder vormt het hart van de app.  
De app start via `main.dart` in de root van `lib`.  
`app.dart` verzorgt de algemene app-structuur.

### Vertalingen

Vertalingen worden geladen via `services/translations.dart`.  
De taal wordt ingesteld en opgeslagen in `SharedPreferences`.

---

Voor vragen of opmerkingen, neem contact op met het ontwikkelingsteam.
