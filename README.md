## El problema ##

Aveces tenemos que volver a usar algún comando o fichero pero no conseguimos recordarlo y ni nos sirve pulsar en ↑ para mirar en el histórico de comando usados porque hay mucha morralla ni nos vale Ctrl+R porque no recordamos bien el nombre.

## La solución ##

`uso` analizara tu historial, ordenara los ficheros más usados (que aún existan) y te los listara de más a menos usado. Tambien prodas pedirle que te muestre comandos en vez de fichero. Y en ambos casos podrás filtrar por palabras o letras.

## Ejemplo de uso ##

Mostrar los ficheros más usados

    pi@bot ~ $ uso
    /var/log/prosody/prosody.log
    /usr/local/bin/hf
    /usr/local/bin/cmd
    /var/log/prosody/prosody.err
    /usr/lib/prosody/modules/mod_takenote.lua
    /usr/local/bin/atajo
    /usr/bin/prosody
    /home/bot/HAL/riddim/plugins/hashtag.lua
    /root/.centerim/config
    /etc/hosts

Mostrar los comandos más usados

    pi@bot ~ $ uso -c
    /etc/init.d/prosody restart
    history | hf
    atajo prosody
    atajo note
    cmd a
    chmod +x /usr/local/bin/hf
    /bin/bash -i -c history
    /usr/local/bin/dwn
    lua HAL/riddim/init.lua
    hg clone http://code.matthewwild.co.uk/verse/ verse

Mostrar los dos ficheros más usados

    pi@bot ~ $ uso 2
    /var/log/prosody/prosody.log
    /usr/local/bin/hf

Mostrar los ficheros más usados que contengan la palabra prosody en su ruta absoluta

    pi@bot ~ $ uso prosody
    /var/log/prosody/prosody.log
    /var/log/prosody/prosody.err
    /usr/lib/prosody/modules/mod_takenote.lua
    /usr/bin/prosody
    /var/log/prosody/prosody.not

Mostrar el comando más usado por el usuario bot y que contenga la palabra lua

    pi@bot ~ $ sudo uso /home/bot/.bash_history -c lua 1
    lua riddim/init.lua

## Apéndice ##

.bash_history no se actualiza en tiempo real así que si necesitas que `uso` analice hasta el últimisimo comando ejecutado debes forzar antes una actualización mediante el comando:
	
    pi@bot ~ $ history -a

No integramos la llamada a "history -a" dentro del script porque necesita ser ejecutado directamente por el usuario para garantizar que se actualice su .bash_history
