# Pottberegner
Pottberegner for kapittel 3.4 go 5 utviklet av Fellesorganisasjonen (FO)

Dette er en enkel webbapp laget i Shiny for R. Appen er ment som et hjelpeverktøy for tillitsvalgte i kommunen for å beregne ut potten til lokale forhandlinger i kapittel 3.4 og kapittel 5 i KS-området. 

NB. Virknignstidspunketet settes til den 01. i den valgte måneden uansett hvilken dato som velges

### Docker: 
Appen har blitt konfigurert for Docker. Kjør følgende
```bash
 docker build -t pottberegner .
```
for å lage et image av dockerfilen. 

```bash
docker run -p :3838 pottberegner
```
Du kan nå frondt end ved å åpne localhost:3838 
