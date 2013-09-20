::Notes
::Il faut exécuter le service “CONQUEST” avec un compte utilisateur/administrateur.
::Dans le gestionnaire des services : clique droit →  propriété →  connexion : sélectionner “ce compte”
::Les paramétre d’impression de l’imprimante et de adobe reader de ce compte vont être pris en compte.
::Adobe reader : Paramètres impression → Options avancées : sélectionner “Laisser l’imprimante déterminer les couleurs”.

::Dépendances
::Imagemagick
::Adobe Reader
::dcmtk : dcmj2pnm

::Conquest DICOM.ini 
::ExportModality0                    = CR
::ExportConverter0                  = isisDirectPrint.cmd "%VPatientName" %VStudyDate %VStudyTime %f %b %p

::Source code
::Param
set "imagickdir=C:\Program Files\ImageMagick-6.8.6-Q16\"
set "acrobatdir=C:\Program Files (x86)\Adobe\Reader 11.0\Reader"
set "reader=AcroRd32.exe"
set "printername=EPSON B-510DN"
set "printerdriver=EPSON B-510DN"
set "printerport=10.0.0.189_1"
::
::declare var 
set rawname=%1
set "date=%2"
set "time=%3"
set "filepath=%4"
set "filename=%5"
set "filedir=%6"
::
:: Convert dicom to tiff (+ot)
dcmj2pnm +ot %filepath% %filedir%\%filename%.tiff
::
:: Butify name
set name=%rawname:^= %
::
:: Parse date
set year=%date:~0,4%
set month=%date:~4,2%
set day=%date:~6,2%
::
:: Parse time
set hour=%time:~0,2%
set minute=%time:~2,2%
set second=%time:~4,2%
::
:: Make final text var
set finaltext=%name%-%day%/%month%/%year%-%hour%:%minute%:%second%
::
::Make a PDF
cd %imagickdir%
convert -units PixelsPerInch %filedir%\%filename%.tiff -density 300 -thumbnail "2240x3265" -background white -gravity center -extent 2240x3265 -gravity North -pointsize 18 -annotate +0+0 %finaltext% %filedir%\%filename%-print.tiff
convert %filedir%\%filename%-print.tiff %filedir%\%filename%-printpdf.pdf
::
::Delete old file
del %filedir%\%filename%.tiff
del %filedir%\%filename%-print.tiff
::
:: Print
cd %acrobatdir%
%reader% /h /t %filedir%\%filename%-printpdf.pdf "%printername%" "%printerdriver%" "%printerport%"
::
::Clean up
EXIT
