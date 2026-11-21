---
title: "Onesimus — Moderne Backup-Verwaltung"
description: "Eine moderne Qt6-Oberfläche und ein stabiler Backup-Stack in Rust: Drop-in-Ersatz für den Bareos Director, mit Bareos als Rückfallweg."

hero:
  badge: "Open Source · AGPL-3.0"
  title: "Eine moderne Backup-Oberfläche."
  titleEm: "Ein stabiler Kern in Rust."
  subtitle: "Onesimus ist eine Qt6-Desktop-Anwendung **und** ein Backup-Stack in Rust: Director, File Daemon, Storage Daemon und Konsole. Er ersetzt Bareos 25 ohne Umbau: dieselbe Konfiguration, derselbe Katalog, dieselben Clients. Und Bareos bleibt als Rückweg installiert."
  actions:
    - label: "Installieren"
      url: "/docs/install/"
      primary: true
    - label: "Onesimus und Bareos im Vergleich"
      url: "/compare/"
    - label: "GitHub"
      url: "https://github.com/Beerlesklopfer/Onesimus"
  screenshot:
    name: "overview"
    alt: "Das Hauptfenster von Onesimus: Reiter Jobs mit der Job-Liste und dem Statistik-Dock"

pillars:
  label: "Warum Onesimus"
  title: "Ein Paket, drei Versprechen"
  items:
    - icon: "🖥️"
      title: "Eine Oberfläche, die du gern benutzt"
      text: "Eine native Qt6-Anwendung für Linux, Windows und macOS, auf Deutsch, Englisch, Spanisch, Französisch, Italienisch und Russisch. Sie spricht gRPC mit TLS zum Onesimus Director und das klassische Konsolenprotokoll zu jedem Bareos Director."
    - icon: "⚙️"
      title: "Stabilität zuerst"
      text: "Der Director `odir` führt jeden Job, der mit einem Daemon spricht, in einem eigenen Prozess aus: Ein abstürzender Job reißt den Director nicht mit. Seine Konsolenausgabe wird Byte für Byte gegen `bconsole` geprüft."
    - icon: "↩️"
      title: "Bareos bleibt dein Rückweg"
      text: "`odir` liest `/etc/bareos/bareos-dir.d` unverändert und nutzt den PostgreSQL-Katalog von Bareos. Beide Directors können installiert bleiben; systemd startet den einen und stoppt den anderen."

showcase:
  label: "Funktionen"
  title: "Was du in Onesimus siehst"
  subtitle: "Bildschirmfotos von einem Demo-Director mit erfundenen Daten."
  items:
    - label: "Jobs"
      title: "Alle Jobs auf einen Blick"
      text: "Der Reiter Jobs listet die Jobs aus dem Katalog, daneben ein Statistik-Dock."
      bullets:
        - "Filter nach Status, Level, Client, Name und Datum"
        - "Job-Details mit Dateien, Bytes, Dauer und Log"
        - "Liste als JSON oder CSV exportieren"
      screenshot:
        name: "overview"
        alt: "Reiter Jobs mit der Job-Liste und dem Statistik-Dock"
    - label: "Live-Job-Log"
      title: "Einem Job beim Laufen zusehen"
      text: "Am Onesimus Director kommt das Job-Log per gRPC in dem Moment, in dem der Director es schreibt, zusammen mit dem Job-Status. An einem Bareos Director fragt die Oberfläche das Log regelmäßig ab."
      badge: "Push-Ereignisse mit dem Onesimus Director"
      screenshot:
        name: "job-log"
        alt: "Ein laufender Job mit seinem Live-Job-Log"
    - label: "Schedules"
      title: "Die ganze Nacht auf einer Zeitachse"
      text: "Der Reiter Schedules zeichnet die Nacht als Gantt-Zeitachse aus gemessenen Job-Laufzeiten und zeigt, wo Jobs aufeinander warten werden."
      bullets:
        - "Editor-Raster: Wochentag × Stunde, nach Level eingefärbt"
        - "Vorschlag zum Entzerren: Startzeiten im 15-Minuten-Raster"
        - "Ein übernommener Vorschlag kopiert den Schedule als `<name>-HHMM`; jede Änderung siehst du, bevor sie geschrieben wird"
      screenshot:
        name: "schedules"
        alt: "Reiter Schedules: Gantt-Zeitachse der Nacht mit vorhergesagten Wartezeiten"
    - label: "Zugriffsrechte"
      title: "Wer was darf, in einer Matrix"
      text: "Die ACL-Matrix zeigt die Rechte jeder Console. Am Onesimus Director legst du in der Oberfläche eine Console mit Profil an und schränkst eine Console mit Katalog-ACLs (`.acl`) weiter ein, ohne eine Konfigurationsdatei anzufassen."
      badge: "Katalog-ACLs mit dem Onesimus Director"
      screenshot:
        name: "acl-matrix"
        alt: "ACL-Matrix der Consoles"
    - label: "Prune & Purge"
      title: "Purge mit Vorschau"
      text: "Das Prune-und-Purge-Panel macht zuerst einen Probelauf und listet, was gepurgt würde. Gepurgt werden nur die Volumes aus der Vorschau, und erst nach deiner Bestätigung."
      bullets:
        - "Viele Volumes auf einmal mit `purge volume all … dryrun|yes` (Onesimus Director)"
        - "Der Onesimus Director purgt nie die Volumes mit der jüngsten Full-Kette eines Clients"
      screenshot:
        name: "purge"
        alt: "Prune-und-Purge-Panel mit der Vorschau des Probelaufs"
    - label: "Restore & 3-2-1"
      title: "Dateien zurückholen, Kopien prüfen"
      text: "Der Restore-Assistent führt dich durch die Job-Auswahl und den Dateibaum. Die 3-2-1-Prüfung zeigt je Job, ob seine Daten in genug Kopien, auf verschiedenen Medientypen und außer Haus liegen."
      screenshot:
        name: "check-321"
        alt: "Dialog der 3-2-1-Prüfung"

features:
  label: "Mehr"
  title: "Gebaut für Administratoren"
  items:
    - icon: "🔌"
      title: "Verbindungsassistent"
      text: "Findet Onesimus Directors im lokalen Netz (mDNS) und merkt sich beim ersten Kontakt das TLS-Zertifikat des Directors. TLS-PSK und Zertifikate für Bareos Directors."
    - icon: "🧩"
      title: "Konfiguration sicher bearbeiten"
      text: "Am Onesimus Director lassen sich Ressourcen anlegen, ändern und löschen (`configure add/update/delete`). Jede Änderung geht vom Rohtext der Konfiguration aus und wird dir gezeigt, bevor sie geschrieben wird."
    - icon: "📖"
      title: "Eine Grammatik für alle Befehle"
      text: "Der Onesimus Director beschreibt seine Konsolenbefehle in einer Grammatik (`.grammar`). Die Befehlsreferenz auf dieser Seite, die Vervollständigung in `oconsole` und die Man-Pages entstehen daraus."
    - icon: "🗂️"
      title: "Backups durchsuchen mit OVFS"
      text: "Neben BVFS durchsucht der Onesimus Director Backup-Inhalte mit OVFS, einer PostgreSQL-Erweiterung, und rechnet dasselbe Ergebnis selbst aus, wo die Erweiterung fehlt."
    - icon: "🤖"
      title: "MCP für KI-Assistenten"
      text: "`oconsole --mcp` bietet den Director KI-Assistenten als typisierte Werkzeuge an. Das ist Konfiguration, kein eigenes Programm: Jede Console, deren Name auf `-mcp` endet, ist eine Assistenten-Console mit eigenem Passwort; das Profil `assistant` erlaubt ihr, zu lesen und die Konfiguration zu ändern. ACL-Änderungen, das Anlegen oder Ändern von Consolen, Profilen und Usern, das Hinterlegen von Programmen und direktes SQL verweigert der Director jeder Assistenten-Console, egal was konfiguriert ist. Kein Werkzeug liefert Backup-Inhalte: Ein Restore, wenn du ihn erlaubst, schreibt die Dateien auf den Client, nie zum Assistenten. [Einrichtung](/de/docs/install/mcp/)"
    - icon: "🌍"
      title: "Sechs Sprachen, zwei Themes"
      text: "Sprache und ein dunkles oder helles Theme wählst du in den Einstellungen."

stack:
  label: "Der Stack"
  title: "Tausche ein Teil oder alle"
  subtitle: "Jeder Onesimus-Daemon liest die Bareos-Konfiguration des Teils, das er ersetzt. Onesimus- und Bareos-Daemons lassen sich mischen."
  items:
    - name: "odir"
      role: "Director"
      text: "Drop-in für `bareos-dir` 25: dasselbe `bareos-dir.d`, derselbe PostgreSQL-Katalog, der klassische Konsolen-Port für `bconsole` und dazu gRPC mit TLS für die Oberfläche."
      fallback: "Rückweg: `bareos-dir`"
    - name: "ofd"
      role: "File Daemon"
      text: "Backup, Restore, Estimate und Verify. Spricht gRPC mit TLS zu `odir` und fällt auf das klassische Protokoll zurück."
      fallback: "Rückweg: `bareos-fd`"
    - name: "osd"
      role: "Storage Daemon"
      text: "Schreibt Volumes im Bareos-Format, die `bls` und `bareos-sd` lesen können. Vorerst File-Devices; bedient auch einen Bareos Director über das klassische Protokoll."
      fallback: "Rückweg: `bareos-sd`"
    - name: "oconsole"
      role: "Konsole"
      text: "Interaktive Konsole über das klassische Protokoll oder gRPC, mit Vervollständigung aus der Grammatik des Directors und einem MCP-Server."
      fallback: "`bconsole` funktioniert weiter"
  note: "Band, S3 und weitere Gerätearten stehen im Plan des Storage Daemons, sind aber noch nicht drin. Was anders ist und was fehlt, steht im [Vergleich mit Bareos](/de/compare/)."

name:
  label: "Der Name"
  title: "Warum Onesimus?"
  text: "Onesimus war im ersten Jahrhundert ein Sklave, der seinem Herrn Philemon davonlief. Fern von zu Hause begegnete er dem Apostel Paulus und durch ihn Jesus Christus. Paulus schickte ihn mit einem kurzen Brief zurück, der heute zum Neuen Testament gehört. Darin spielt er mit dem Namen, der *nützlich* bedeutet:"
  quotes:
    - text: "… der dir früher unnütz war, jetzt aber dir und mir sehr nützlich ist."
      source: "[Philemon 11](https://www.bibleserver.com/LUT/Philemon1)"
    - text: "Jesus Christus spricht: „Denn der Menschensohn ist gekommen, zu suchen und selig zu machen, was verloren ist.“"
      source: "[Lukas 19,10](https://www.bibleserver.com/LUT/Lukas19)"
  closing: "Verloren, gefunden, wiederhergestellt: Dafür gibt es Backups. Und genau das bietet Gott jedem Menschen in Jesus Christus an. Wir haben die Software nach Onesimus benannt, weil wir das glauben. Der Brief an Philemon ist eine Seite lang; [lies ihn](https://www.bibleserver.com/LUT/Philemon1)."

cta:
  title: "Probier es neben deiner Bareos-Installation aus"
  text: "Onesimus ist Open Source unter der AGPL-3.0 und noch nicht so etabliert wie Bareos. Installiere es zuerst auf einem Testsystem; der Weg zurück zu Bareos ist ein `systemctl`-Befehl."
  actions:
    - label: "Installation & Betrieb"
      url: "/docs/install/"
      primary: true
    - label: "Auf GitHub ansehen"
      url: "https://github.com/Beerlesklopfer/Onesimus"
---
