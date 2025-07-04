TODO
====

## Chord Chapter Implementation

- enhance and Optimize Chord User Experience
  - Alle activities sollen bei erfolg den Regenbogen anzeigen (aus feedback.js)

  - **2_1_chords_color-matching**:
   - Implementiere Tone.js Audio-Engine-Integration für Akkord-Wiedergab
   - progression:
    - at first only minor or major
    - if 10 right level 2: add Diminished
    - if 10 right level 3: add Augmented
    - if 10 right level 4: add Sus4
    - if 10 right level 5: add Sus2 
   - add a free play mode where the user can play any chord by clicking on the color
    

  - **2_2_chords_mood-landscapes**:
   - es spielt noch kein sound
    - Aktiviere Audio-Wiedergabe für Akkordprogressionen
    - schlage landschaften vor

  - **2_3_chords_chord-building**:
     - Füge einen neuen Button hinzu, um den vollständigen gebauten Akkord dann auch  abzuspielen

  - **2_4_chords_missing-note**:
    - Vereinfache die Aktivität für jüngere Kinder, so ist sie viel zu schwer
    - Stelle sicher, dass alle Akkordaktivitäten eine konsistente UI haben
    - Implementiere kindgerechtes visuelles Feedback bei Akkordwiedergabe
    - schlage etwas vor

  - **2_5_chords_characters**:
   - es spielt noch kein sound
   - Implementiere Tone.js Audio-Engine-Integration für Akkord-Wiedergabe
   
  - **2_6_chords_harmony-gardens**:
   - es spielt noch kein sound
   - Aktiviere Audio-Wiedergabe für Akkordsequenzen

dabei:
- Überprüfe ob alle mit tone.js umgesetzt wurden

- beachte FILESTRUCTURE.md und CODING_STANDARDS.md

- in "chords" use the same piano as in "pitches" export the piano functionality to a shared component and reuse it


## First finish pitches and melodies completely:

- Enhance Visual Experience
    - Improve animations and visual feedback
    - Add friendly character animations
    - Ensure rewarding visual feedback for all interactions

- Rules aus concept.md generieren

- Add Child-Friendly Guidance
    - Implement recurring character guides throughout chapters

- Wie sichere ich die Spieler Fortschritte? 
    - Backup auf Server

- Create unique visual spaces for each chapter

- Mobile Deployment
    - Ensure proper touch interactions for mobile
- AI Integration
    - Implement voice guidance with text-to-speech
    - Create adaptive exercise scenarios
    - Develop test cases for different child interactions

- Cookie Banner


unter chrome auf dem handy android 15:
-Multi Touch: wenn mulititouch bemerkt wird, alle anderen touchs ignorieren und trotzdem den knopf drücken, also den letzten, der zählt

- Regenbogen ist im breiten screen zu weit links

- ergänze ein debug flag, das die console logs nur ausgibt, wenn man die app  im debug mode startet, nicht aber wenn man diese deployed oder als android app startet (already started to be implemented with `debugLog`)


- es kann passieren, dass der lock nicht mehr unlockbar ist, wenn man irgendwie den screen breiter zieht, dann lockt und dann wieder schmaler und dann den screen reloaded. ich weis aber noch n icht genau welche combo dazu führt. in dem fall kann man: localStorage.clear();

- nach der erfolgsmeldung wird die z-index erniedrigt, das soll aber auch on top bleiben also über der box mit dem Fortschritt


- main.css und pitch-cards.css zusammenführen in einer strukturierten main.css:
    - Alle Stile in einer Datei mit klaren Abschnitten
    - Sektionenkommentare zur besseren Navigation
    - nicht benutzte stile entfernen

# mascot message:
    - tts disablen
    - die richtige zugehörige mascot message überall soll direkt wenn man die activity öffnet kommen. im moment kommt die alte message, wo man vorher war in dem mascot message container
    - es soll niemals eine mascot message starten, wenn man in irgendeiner activity auf den play button drückt
    - die einstellungen haben erst nach einem neuladen effekt, ohne bleibt die message bleibt verschwunden
    - in preferences ein kleines mascot bild neben die einstellung zum hiden
    - hilfstexte selbst einsprechen oder einmal generieren lassen als mp3

- reachable via a hash-anchor-link: make this link go directly to the 1_1_pitches_high_or_low activity: https://multipaint.z11.de/#1_pitches-1_1_pitches_high_or_low

- all chapters and activities are included in the sitemap. also, if you select another activity in the nav, the hash tag should change, so you can bookmark them

Dies soll in allen aktionen:
- immer bei Misserfolg (error): den sound abspielen und den hintergrund hin und her-wackeln (.shake-error)


- "background-image: 1s ease" funktioniert noch nicht

- Verschiedene Instrumente


- store username and language in export string in Preferences

- übersetze Credits, ... @index.html#L912-935 dies und @index.html#L973 und @index.html#L963-964 @index.html#L883-893 @index.html#L896-908 @pitches.js#L3356-3359 

- when pressed on a button, the finger moves and is released, it should also trigger the buttons click event

- überall den border-shadow focus nach dem click entfernen

reset-button:
- wenn der auto-detect immer geht, dann kann der parameter currentMode in der funktion ja weg in function resetCurrentActivity(currentMode)

- volume level einstellbar machen

- ganz viel ist noch strings hartkodiert mit `isGerman`

# play store:
- In die Texte dass der Bildschirm gesperrt ist
- "Images created with ChatGpt mindfull. Loving prompts" verbessern
- Finanzierung durch unlock button mit link zu Crowd funding

- referral count page aus den settings aufrufbar machen
- das template in dem partial refferer.html funktioniert nichdt, ev. templates werden in partials nicht gaufgelöst? in commit 4d82fbca wurde ein äjhnliches problem gelöst


## nach kapitel

1_1 "High or Low?" (1_1_pitches_high_or_low) 
- max 3x hintereinander der selbe high or low bereich
- # bereit zur veröffentlichung
- die tiefen töne sind eine oktave zu tief
- der reset button in der navi muss auch die fortschrittsanzeige aktualisieren
- ändere, dass man immer 1s warten muss, bis man wählen kann, welche Taste man drückt. man soll sofort, wenn man den ton hört schon wählen dürfen
- die Welle muss Sägezahn sein ohne Brandung 
- im master level dürfen die töne maximal 3 halbtöne auseinander sein und der erste ton muss nicht mehr C5 sein, sondern kann jeder beliebige sein, es wird nur getestet, ob der 2. ton dann höher oder tiefer ist
- die erfolgsmeldung muss sich ab level 3 aendern in "der ton war höher" anstatt "hoch" und "der ton war tiefer" anstatt "tief"

- Entferne alle Überbleibsel der alten "Listen to melodies"-Funktionalität:
   - Lösche unnötige Melodie-Abspielfunktionen für die alte Aktivität

- die meisten activities sollen einen free- und einen game-mode haben, in dem man die sounds ausprobieren kann (free) oder das game spielt, bei dem man die richtigen buttons drücken muss, der die richtigen effekte zeigt aus `feedback.js`

- Die volle  bildschirmbreite Aus nutzen auf dem Handy



1_2 "Match the Sounds":
- direkt nach dem Wechsel für die Welle spielt er immer noch keine Welle. 
- # bereit zur veröffentlichung
- der reset button in der navi muss auch den hintergrund und die anzeige unten triggern, dass die refresht wird, im moment wird der dann noch einfach weiss

1_3 Draw a Melody:
- der Besen Button ist nicht erreichbar (zu weit unten)
- # bereit zur veröffentlichung
- reset all progress geht noch nicht
- wenn der zeichenpfad spitze ecken hat, dann sollen noten, die nahe der spitze sind ganz in die spitze rutschen
- wenn man beim malen den rand des canvas überschreitet, sollte der strich weiter im canvas gemalt werden, an der kante entlang
- Wenn man einen Ton trifft, die Note aufleuchten verbessern, vielieicht den strich an der stelle dick machen oder so

1_4 Does It Sound Right:
- Tiere beim Melodie raten sind noch zu weit unten positioniert
- Funkel, Funkel kleiner setern klingt seltsam
- # bereit zur veröffentlichung
- der reset button in der navi muss auch die fortschrittsanzeige aktualisieren
- when the "next melody" button is pressed in the "Does It Sound Right?" activity, the animal images should NOT change
- fix gebogenen text
- es kommt mehrmals in log "Generated sound judgment melody:..."
- die tonlängen Stimmen noch nicht alle. 
- die tiere müssen noch durchsichtigen rand haben:
- baue die lieder im TODO block im pitches.js
- auch erst einen Modus, wo man nur drauf drückt, ohne die good or bad Tiere unten.
- jede der drei Tiere mit einem anderen Instrument
- Und dann im Game Modus alle drei instrumente zusammen
- eigene melodien hochladen


1_5 memory game:
  - # bereit zur veröffentlichung
  - feedback sound soll mit verzögerung abgespielt werden

2_5_chords_color_matching:
  - Major und  minor soll tendentiell öfter kommen
  - Erster akkord nach progress Wechsel soll immer der neue sein
  - automatisch den neuen akkord spielen
  - reset auch im activity reset, im-und export berücksichtigen
  - es fehlt ein error feedback shake und der sound
  - free play mode bevor man den play button drückt
  - # bereit zur veröffentlichung
  - bei progress >=30 sollen die akkorde in der höhe durch einen transpose faktor von +-6 halbtönen variieren:
    - bis 40 schlagen eichhörnchen und octopus in hintergrund, bei 50 wacht das eichhörnchen wieder auf, ... 
  - es soll der erfolgssound kommen
  - wenn man während der regenbogen läuft drückt, soll schon der neue akkord abgespielt werden und nicht der letzte

# mobile-build.sh:
- die find funktion, die nur das kopieren soll was benutzt wird passiert zu spät, es wird vorher schon mit rsync alles von public/ nach dist/ kopiert. ich habe den original folder da hinzugefügt, aber es wäre schöner, wenn das automatisch nicht gersnynct würde, wenn es nicht bnutzt wird
- option um die icons neu zu machen, defualt ausgeschaltet

-------------------------------------------
- Background-Bilder Lazy load testen

 - back button in android gesondert handeln: der back-button soll da zurück ins menu gehen, aber nur, wenn die navigation nicht gelockt ist.

- exportProgress funktioniiert nicht merh, wenn man garbage importiert hat

- Webpack-Bundle-Analyzer verwenden um große Abhängigkeiten zu identifizieren

- build for ios
- class .debug-elements always hidden in production

# most important


Implementiere eine robuste Tonzufalls-Steuerung für die 1_1-Aktivität der multipaint-App mit doppelter Beschränkung:

1. DOPPELTE BESCHRÄNKUNG:
   - Maximal 3 identische Tonbereiche (hoch/tief) dürfen nacheinander erscheinen
   - NIE den EXAKT gleichen Ton zweimal hintereinander verwenden
   - Beide Regeln müssen gleichzeitig erfüllt sein
   - Diese Beschränkungen gelten für ALLE Progress-Levels gleichmäßig

2. TRACKING-VARIABLEN:
   - `consecutiveSameRangeCount`: Zählt aufeinanderfolgende gleiche Bereiche
   - `previousToneRange`: Speichert den vorherigen Tonbereich ('high' oder 'low')
   - `previousExactTone`: Speichert den zuvor generierten exakten Ton (z.B. 'C5')
   - Bei der Initialisierung: Diese Variablen auf 0, null bzw. null setzen

3. IMPLEMENTIERUNGSLOGIK:
   - In [getRandomTone1_1()](cci:1://file:///var/www/Musici/src/components/pitches.js:777:4-790:5): 
     - Einen Ton wählen, der NICHT `previousExactTone` entspricht
     - Wenn Filter nötig: Array filtern und zufälligen Ton aus den verbleibenden wählen
   
   - In `generate1_1HighOrLowSequence()`:
     - Wenn `consecutiveSameRangeCount >= 3`: ERZWINGE den entgegengesetzten Bereich
     - Bestehende `isSameAsPrevious`-Logik beibehalten, um exakte Rätselduplikate zu vermeiden
     - Nach erfolgreicher Generierung: Update von `previousToneRange` und `consecutiveSameRangeCount`
       - Wenn gleicher Bereich: Inkrementiere `consecutiveSameRangeCount`
       - Wenn anderer Bereich: Setze `consecutiveSameRangeCount` auf 1
     - Speichere den generierten Ton in `previousExactTone`

4. DEBUGGING:
   - Logging mit dem Tag [1_1_RANDOM] für alle relevanten Schritte
   - Logge Zustand vor/nach der Auswahl: "Vor Auswahl: count=X, prevRange=Y, prevTone=Z"
   - Bei erzwungenen Wechseln klar markieren: "ERZWUNGEN: Wechsel zu entgegengesetztem Bereich"

Implementiere diese Logik in `generate1_1HighOrLowSequence()` und [getRandomTone1_1()](cci:1://file:///var/www/Musici/src/components/pitches.js:777:4-790:5), wobei beide Beschränkungen korrekt umgesetzt werden müssen.

