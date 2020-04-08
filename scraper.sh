#/bin/bash

meses="ene
		feb
		mar
		abr
		may
		jun
		jul
		ago
		sep
		oct
		nov
		dic"

anhos="2019"
	  # 2018
	  # 2017"

letras="ab
	  	cd
	   	efg
		hijkl
		mno
		pqr
		stu
		vwxyz" 

link="http://web.uchile.cl/transparencia/"


# las rentas de agosto tienen problemas con los acentos

for tipo in "planta" "contrata"; do
	for anho in $anhos; do
		for mes in $meses; do
			touch "datos/${anho}${mes}_${tipo}.tsv"
			echo -e "\n${tipo} ${mes} ${anho}"
			for let in $letras;do
				# https://stackoverflow.com/questions/1403087/how-can-i-convert-an-html-table-to-csv
				echo -e '\t' "Scraping:" "${link}${tipo}${mes}${anho}${let}.html" 
				
				curl "${link}${tipo}${mes}${anho}${let}.html" 2>/dev/null | \
				sed "0,/<tbody>/Id" | \
				grep -i -e '</\?TABLE\|</\?TD\|</\?TR\|</\?TH' |\
				sed 's/^[\ \t]*//g' | tr -d '\n' | \
				sed 's/<\/TR[^>]*>/\n/Ig'  | \
				sed 's/<\/\?\(TABLE\|TR\|TBODY\)[^>]*>//Ig' |\
				sed 's/^<T[DH][^>]*>\|<\/\?T[DH][^>]*>$//Ig' |\
				sed 's/<\/T[DH][^>]*><T[DH][^>]*>/\t/Ig' | \
				sed 's/&aacute;/á/g; s/&eacute\;/é/g; s/&iacute;/í/g; s/&oacute;/ó/g; s/&uacute;/ú/g; s/&ntilde;/ñ/g; s/&Aacute;/Á/g; s/&Eacute\;/É/g; s/&Iacute;/Í/g; s/&Oacute;/Ó/g; s/&Uacute;/Ú/g; s/&Ntilde;/ñ/g;' \
				 >> "datos/${anho}${mes}_${tipo}.tsv"
			done
		done
	done
done

for anho in $anhos; do
	for mes in $meses; do
		echo -e "\nhonorarios ${mes} ${anho}"

		for let in "abc" "defghijkl" "mnopqr" "stuvwxyz" ;do
			touch "datos/${mes}${anho}_honorarios.tsv"
			echo -e '\t' "Scraping:" "${link}honorarios${mes}${anho}${let}.html" 

			curl "${link}honorarios${mes}${anho}${let}.html" 2>/dev/null | \
			sed "0,/<tbody>/Id" | \
			grep -i -e '</\?TABLE\|</\?TD\|</\?TR\|</\?TH' |\
			sed 's/^[\ \t]*//g' | tr -d '\n' | \
			sed 's/<\/TR[^>]*>/\n/Ig'  | \
			sed 's/<\/\?\(TABLE\|TR\|TBODY\)[^>]*>//Ig' |\
			sed 's/^<T[DH][^>]*>\|<\/\?T[DH][^>]*>$//Ig' |\
			sed 's/<\/T[DH][^>]*><T[DH][^>]*>/\t/Ig' | \
			sed 's/&aacute;/á/g; s/&eacute\;/é/g; s/&iacute;/í/g; s/&oacute;/ó/g; s/&uacute;/ú/g; s/&ntilde;/ñ/g; s/&Aacute;/Á/g; s/&Eacute\;/É/g; s/&Iacute;/Í/g; s/&Oacute;/Ó/g; s/&Uacute;/Ú/g; s/&Ntilde;/ñ/g;' \
			 >> "datos/${anho}${mes}_honorarios.tsv"				
		done
	done
done


mkdir datos_limpios
touch "datos_limpios/sueldos.tsv"
touch "datos_limpios/personal.tsv"

for tipo in "planta" "contrata"; do
	for mes in $meses; do
		for anho in $anhos; do
		# eliminar filas vacias
		sed -i '/^\s\s*/d' "datos/${anho}${mes}_${tipo}.tsv"
		# eliminar columnas innecesarias | agregar anho y mes a los datos
		# cut -d$'\t' -f9,11 --complement "datos/${anho}${mes}_${tipo}.tsv" | awk -v anho=$anho -v mes=$mes '{print anho "\t" mes "\t" $0}' >> "datos_limpios/sueldos.tsv" 
		cut -d$'\t' -f1-2,6-17 --complement "datos/${anho}${mes}_${tipo}.tsv" >> datos_limpios/personal_tmp.tsv
		done
	done
done

touch "datos_limpios/honorarios.tsv"

for mes in $meses; do
	for anho in $anhos; do
	# eliminar filas vacias

	sed -i 's/"//g' "datos/${anho}${mes}_honorarios.tsv"
	sed -i '/^\s\s*/d' "datos/${anho}${mes}_honorarios.tsv"

	# eliminar columnas innecesarias | agregar anho y mes a los datos
	cut -d$'\t' -f6-8 --complement "datos/${anho}${mes}_honorarios.tsv" | awk -v anho=$anho -v mes=$mes '{print "HONORARIOS" "\t" anho "\t" mes "\t" $0}' >> "datos_limpios/honorarios.tsv" 
	done
done


sort -u datos_limpios/personal_tmp.tsv > datos_limpios/personal.tsv
rm datos_limpios/personal_tmp.tsv