::Création des répertoires locaux
mkdir user_local
mkdir sphinx_local
mkdir user_local\sph

::Partage du dossier user_local
NET SHARE user_local=C:\user_local /GRANT:"Tout le monde",FULL

::Création des lettres réseaux
NET USE /delete * /yes
NET USE R: \\192.168.1.100\medisphinx /persistent:yes
NET USE P: \\127.0.0.1\user_local /persistent:yes
NET USE N: \\192.168.1.100\conquest /persistent:yes

::Copie des fichier sphinx du serveur vers le dossier local
R:
for %%f in (aiguillage.exe,apicript.exe,FOXUSER.DBF,FOXUSER.DBF,FOXUSER.FPT,histperdu.exe,medisphinx.dbf,modele.exe,msvcp70.dll,msvcr70.dll,session.exe,sphinxnv.exe,vfp8r.dll,VFP8RENU.DLL) do xcopy /y %%f C:\sphinx_local