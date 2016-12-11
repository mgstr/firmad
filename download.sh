curl -sO http://avaandmed.rik.ee/andmed/ARIREGISTER/ariregister_csv.zip
unzip ariregister_csv.zip -d data/
ls data/ettevotja_rekvisiidid_*.csv | head -1 | grep -oP '\d\d\d\d-\d\d-\d\d' >data/export-date.csv     # remember data exporting date
mv data/ettevotja_rekvisiidid_*.csv data/ettevotja_rekvisiidid.csv                                      # rename file for importing