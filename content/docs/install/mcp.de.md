---
title: "KI-Assistenten (MCP)"
description: "Einen KI-Assistenten mit oconsole --mcp an den Onesimus Director anbinden: eigene Console, Profil assistant, die Grenzen, die der Director durchsetzt, stdio und HTTP."
weight: 6
---

`oconsole --mcp` bietet den Director einem KI-Assistenten über das
[Model Context Protocol](https://modelcontextprotocol.io) (MCP) an: typisierte Werkzeuge wie
`list_jobs`, `status_director`, `show` oder `configure_update` statt freier Befehlszeilen. Die
Verbindung zum Director ist dieselbe wie in der interaktiven Konsole, über das klassische
Konsolenprotokoll oder über gRPC (`--grpc`).

Der Assistent bekommt nicht deine Rechte. Er meldet sich als eigene Console an, und der Director
entscheidet, was diese Console darf.

<div class="note">

**Kein eigenes Programm, nur Konfiguration.** Die Assistenten-Console ist kein zusätzlicher Dienst und
kein eigenes Werkzeug. Sie ist eine gewöhnliche `Console`-Ressource in der Konfiguration des Directors,
und besonders macht sie nur ihr Name: **Jede Console, deren Name auf `-mcp` endet, ist eine
Assistenten-Console.** Der Director wendet die Assistenten-Regeln auf sie an, egal mit welchem Client
sie sich anmeldet (`oconsole --mcp`, `bconsole`, die GUI), und keine Einstellung hebt sie auf. Zum
Einrichten legst du eine `Console` an und gibst ihr das Profil `assistant`; zum Entfernen löschst du
diese Ressource.

</div>

## Die eigene Console des Assistenten

`oconsole --mcp` meldet sich immer als **`<name>-mcp`** an. `<name>` ist die erste `Console` in
`oconsole.conf` ohne diese Endung (oder der mit `--name` angegebene Name). Das Passwort kommt aus der
Ressource `Console { Name = <name>-mcp; … }` derselben Datei, nie aus deiner eigenen Console.

Fehlt diese Console in `oconsole.conf` (oder steht dort nur `*UserAgent*`), startet
`oconsole --mcp` nicht: Es endet mit Status 2 und nennt die Zeilen, die du ergänzen musst. Auf deine
Rechte fällt es nie zurück. Ohne `--mcp` meldet sich oconsole wie bisher mit deiner Console an, auch
wenn die `-mcp`-Console in der Datei zuerst steht.

`--name <x>-mcp --password …` wählt eine Assistenten-Console ausdrücklich. oconsole erkennt die Endung nur kleingeschrieben: `--name X-MCP` gilt als dein eigener Name und meldet sich als `X-MCP-mcp` an.

## Was der Assistent darf

Es gelten die Rechte der Console-Ressource `<name>-mcp` in der Konfiguration des Directors. Für
diese Console gibt es das Profil **`assistant`**:

- **Lesen:** `status`, `show`, `list`, `llist`, `messages`, `version`, `time`, `help`, `whoami`,
  `estimate` und die lesenden Punktbefehle (`.jobs`, `.clients`, `.pools`, `.schedule`, …), auch das
  Durchsuchen der Dateien mit `.bvfs_*` und `.ovfs_*`.
- **Konfiguration ändern:** `configure`, also Job-, JobDefs-, Schedule-, Client-, FileSet-, Pool- und
  Storage-Ressourcen anlegen, ändern und löschen. Jede Änderung durchläuft die Prüfungen des
  Directors, wie aus der GUI, und eine Assistenten-Console kann kein Programm hinterlegen, das der
  Director ausführen würde (siehe unten).
- **Nicht:** `run`, `restore`, `purge`, `delete`, `cancel`, `label`, `reload`. Diese Befehle stehen
  nicht im Profil, also lehnt der Director sie ab.

Das Profil erlaubt alle Jobs, Clients, Storages, Schedules, Pools, FileSets und Catalogs. Schränke das
in der Console-Ressource ein, wenn der Assistent nur einen Teil der Installation sehen soll.

### Mehr erlauben

Soll der Assistent mehr können, trägst du das **nur in seiner Console** ein, mit den üblichen
ACL-Direktiven von Bareos. Zuerst gelten die Einträge der Console selbst, dann ihre Profile; wie in
Bareos entscheidet der erste passende Eintrag, und ein Eintrag mit `!` verbietet.

```text
Console {
  Name = admin-mcp
  Password = "…"
  Profile = assistant
  Command ACL = run, restore      # zusätzlich zum Profil
  Where ACL = /srv/restore        # Restores dürfen nur hierhin schreiben
}
```

Bei Restores begrenzt die **`Where ACL`**, wohin ein Restore auf dem Client schreiben darf; ein
`where` außerhalb davon wird abgelehnt. Das Profil `assistant` hat keine `Where ACL`.

Zerstörende Werkzeuge (`relabel_volume`, `prune`, `purge` außer im Probelauf, `delete`, `truncate`, `configure_delete`)
verlangen zusätzlich den Parameter `confirm: true`. Ohne ihn bittet das Werkzeug den Assistenten, erst
bei dir nachzufragen, und schickt nichts an den Director.

## Grenzen, die keine Konfiguration aufhebt

Für jede Console, deren Name auf `-mcp` endet (Groß- und Kleinschreibung egal), lehnt der Director
diese Befehle ab, gleich was ihre ACLs und Profile sagen, auch mit `Command ACL = *all*`:

| Abgelehnt | Warum |
|---|---|
| ACL-Änderungen (`.acl`, die ACLs im Katalog) | Der Assistent könnte seine eigenen Grenzen aufheben |
| `sqlquery`, `.sql`, `query` | rohes SQL: der einzige Weg zu Inhalten, die im Katalog gespeichert sind |
| Consolen, Profile und User anlegen oder ändern (`configure add console\|profile\|user`; `configure update/delete` kennen diese Typen nicht) | Profile und User sind Konfigurationsressourcen, die ACLs tragen; ein Assistent legt keine an und ändert keine |
| `RunScript`, `Run Before/After (Failed) Job`, `Client Run Before/After Job`, `Plugin`, `File = "\|…"`, `Write Bootstrap = "\|…"` in einer Konfigurationsänderung | Ein Assistent hinterlegt kein Programm: Ein Zeitplan würde es als Benutzer des Directors ausführen |

Alles andere folgt den ACLs der Console. Die Rechte des Assistenten änderst du von deiner eigenen
Console aus oder in der Konfiguration, nie von seiner.

## Der Assistent kann deine Backups nicht lesen

Kein Werkzeug liefert den Inhalt gesicherter Dateien:

- `ovfs_*`, `bvfs_*` und die Werkzeuge `restore_tree_*` liefern **Namen und Metadaten** (Pfade,
  Größen, Zeitpunkte, Versionen), keine Dateiinhalte.
- Ein Restore, wenn du ihn erlaubst, ist ein Job des Directors: Der Storage Daemon schickt die Daten an
  den **Client**, der sie auf seine Platte schreibt. Zum Assistenten kommt nichts zurück; das Werkzeug
  liefert die JobId.
- Rohes SQL ist verboten (siehe oben), also kann der Assistent auch keine gespeicherten Objekte aus dem
  Katalog lesen.

Ist der Rechner, auf dem der Assistent läuft, selbst ein Backup-Client, landet ein Restore auf diesen
Client auf seiner Platte. Lass `restore` für den Assistenten dann aus, oder begrenze es mit
`Client ACL` und `Where ACL`.

## Einrichten

**1. Die Console in der Konfiguration des Directors**, zum Beispiel in
`bareos-dir.d/console/admin-mcp.conf`:

```text
Console {
  Name = admin-mcp
  Description = "KI-Assistent"
  Password = "ein-langes-zufaelliges-passwort"
  Profile = assistant
}
```

Du kannst sie auch in der GUI anlegen oder mit `configure add console` von deiner eigenen Console aus.
Das Profil `assistant` muss in der Konfiguration stehen (`bareos-dir.d/profile/assistant.conf`).

**2. `oconsole.conf`** auf dem Rechner, auf dem der Assistent läuft: deine Console und die des
Assistenten, jede mit eigenem Passwort.

```text
Director {
  Name = backup-dir
  Address = backup.example.org
  Password = "…"
}
Console {
  Name = admin
  Password = "…"
}
Console {
  Name = admin-mcp
  Password = "ein-langes-zufaelliges-passwort"
}
```

`oconsole --mcp` meldet sich dann als `admin-mcp` an.

**3. Den MCP-Server starten.**

Über **stdio** (der Assistent startet oconsole als lokalen Prozess):

```bash
oconsole --mcp            # Lese-, Schreib- und Restore-Werkzeuge, soweit die ACLs der Console es erlauben
oconsole --mcp --grpc     # dasselbe über gRPC mit TLS
oconsole --mcp --mcp-read-only   # nur die Lese-Werkzeuge
```

Über **HTTP** (Streamable HTTP unter `/mcp`, mit Bearer-Token):

```bash
oconsole --mcp --mcp-http 127.0.0.1:9104
```

oconsole legt die Token-Datei beim ersten Start an (`~/.config/oconsole/mcp.token`, Modus 0600; einen
anderen Ort wählst du mit `--mcp-token-file`) und nennt URL und Datei. `--mcp-host` fügt einen
Hostnamen hinzu, den der Server im HTTP-Header `Host` annimmt. **Über HTTP bietet der Produktions-Build
nur die Lese-Werkzeuge**, gleich was die ACLs der Console erlauben; Schreib-Werkzeuge über HTTP gibt es
nur in Entwicklungs-Builds.

Welche Werkzeuge der Assistent sieht, hängt vom Transport ab; was er tatsächlich darf, entscheidet
immer der Director anhand der `-mcp`-Console.
