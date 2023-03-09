#!/bin/bash

##################################################################################################################
# conversorTemperatura.sh  é um programa que foi desenvolvido, com fins didáticos, durante a disciplina          #
# IEF829 - Informática no Ensino de Física, oferecida pelo Departamento de Física do Instituto de Ciências       #
# Exatas da Universidade Federal do Amazonas, durante o 1° Semestre letivo de 2022. Ele foi desenvolvido com o   #
# objetivo de mostrar aos estudantes do curso de Licenciatura em Física que é possível criar softwares           #
# relacionados à conteúdos de Física, os quais podem ser usados como ferramenta didática durante os processos    # 
# de ensino e aprendizagem.                                                                                      #
# Copyright (C) <2023>  <J.R.M. Monteiro > | e-mail: joziano@protonmail.com | Version 1, Feb 2023                #
##################################################################################################################

############################################################################################ c ###################
# LICENSE INFORMATION                                                     ################## o ###################
#                                                                         ################## n ###################
# This program is free software: you can redistribute it and/or modify    ################## v ###################
# it under the terms of the GNU General Public License as published by    ################## e ###################
# the Free Software Foundation, either version 3 of the License, or       ################## r ###################
# (at your option) any later version.                                     ################## s ###################
#                                                                         ################## o ###################
# This program is distributed in the hope that it will be useful,         ################## r ###################
# but WITHOUT ANY WARRANTY; without even the implied warranty of          ################## T ###################
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the           ################## e ###################
# GNU General Public License for more details.                            ################## m ###################
#                                                                         ################## p ###################
# You should have received a copy of the GNU General Public License       ################## e ###################
# along with this program.  If not, see <https://www.gnu.org/licenses/>5. ################## r a t u r a . s h ###
##################################################################################################################

# Considerando a possibilidade de exibição de uma informação inicial sobre o 
# programa usando a opção --text-info do zenity (https://help.gnome.org/users/zenity/), 
# iremos configurar um arquivo HTML com o texto que será exibido. O nome do arquivo HTML 
# que será criado será (no presente caso), info.html. Usaremos o comando cat para escrevê-lo,
# sendo EOF (Pode ser qualquer nome) um marcador (ou identificador). Todo texto escrito entre a 
# linha que inicia o comando cat, e o marcador EOF (de End Of File), será escrito no
# arquivo info.html.

cat << EOF > info.html
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8"/>
<title>Document</title>
</head>
  <body bgcolor=yellow>
	<p>
	<font color="red"> 
	Este programa foi desenvolvido durante a disciplina IEF829 - Informática no Ensino de Física, 
	oferecida pelo Departamento de Física do Instituto de Ciências Exatas da
	 Universidade Federal do Amazonas, no 1° Semestre de 2022.
	</font>
	</p>
	
	<p>
	<font color="green">
	Ele realiza conversão entre escalas de temperatura.
	</font>
	</p>
	
	<p>
	<font color="blue">
	Este software é de uso livre para fins didáticos e
	educacionais."
	</font>
	</p>
		
  </body>
</html>
EOF

# Agora, iremos criar a interface gráfica usando o zenity. Esta interface gráfica inicial
# Usará a opção --text-info. Você pode consultar mais opções em: 
# https://help.gnome.org/users/zenity/stable/

zenity --text-info --html --title="Sobre este Software" \
       --filename="./info.html" \
       --checkbox="Eu li e aceito os termos."
	     
# Adicionamos aqui uma condição. A expressão $? captura o status da execução do passo anterior
# se houve execução com sucesso, $? terá valor (status) 0, mas se o botão cancelar ou o "x" forem
# pressionados, $? terá valor (status) 1. Então, a condição adicionada aqui é para encerrar o 
# programa, nesta etapa, se o status for diferente de 0. A expressão != significa diferente, na sintax
# do Shell Script. Traduzindo: Se o status do passo anterior for diferente de zero, então saia.
# Observação: o espaçamento presente no inicio e fim dos colchetes é necessário, se não houver
# esse espaçamento irá ocorrer um erro na execução. 
       
if [ $? != 0 ]
then
	exit
fi

rm info.html
    
status=1
while [ $status == 1 ]
do 
	dados=$(
	    zenity --forms \
	    --title="IEF829 - Informática no Ensino de Física" \
	    --text="Conversor entre escalas de temperatura"\
	    --add-combo="Escala inicial" \
	    --combo-values="Celsius|Fahrenheit|Kelvin" \
	    --add-combo="Escala final" \
	    --combo-values="Celsius|Fahrenheit|Kelvin" \
	    --add-entry="Valor a ser convertido" 
	       )
	       
	if [ $? != 0 ]
	then
		exit
	fi
	
	escalaInicial=$(echo $dados | cut -d \| -f1)
	escalaFinal=$(echo $dados | cut -d \| -f2)
	valor=$(echo $dados | cut -d \| -f3 | sed 's/,/\./g')

	# Precisamos conferir se os campos das escalas estão vazios ou se as escalas inicial e final são iguais, caso isso ocorra,
	# uma mensagem de erro será exibida e o programa será encerrado.
	
	if [ -z $escalaInicial ]
	then
		zenity --error --text="Atenção: um erro ocorreu, selecione corretamente as escalas." --width="200"
		exit
	fi

	if [ -z $escalaFinal ]
	then
		zenity --error --text="Atenção: um erro ocorreu, selecione corretamente as escalas." --width="200"
		exit
	fi
	
	if [ $escalaInicial == $escalaFinal ]
	then
		zenity --error --text="Atenção: um erro ocorreu, as escalas inicial e final são iguais." --width="200"
		exit
	fi

	# Precisamos conferir se o valor inserido é um valor real, caso não seja, uma mensagem de erro
	# será exibida e o programa será encerrado.

	if [[ $valor =~ ^-?[0-9]+([.][0-9]+)?$ ]]
	then
		if [ $escalaInicial == "Celsius" -a $escalaFinal == "Fahrenheit" ]
		then
			temperatura=$(echo "(9/5)*$valor+32" | bc -l)
		fi

		if [ $escalaInicial == "Fahrenheit" -a $escalaFinal == "Celsius" ]
		then
			temperatura=$(echo "5*($valor-32)/9" | bc -l)
		fi

		if [ $escalaInicial == "Celsius" -a $escalaFinal == "Kelvin" ]
		then
			temperatura=$(echo "$valor+273.15" | bc -l)
		fi

		if [ $escalaInicial == "Kelvin" -a $escalaFinal == "Celsius" ]
		then
			temperatura=$(echo "$valor-273.15" | bc -l)
		fi

		if [ $escalaInicial == "Fahrenheit" -a $escalaFinal == "Kelvin" ]
		then
			temperatura=$(echo "(5*($valor-32)/9)+273.15" | bc -l)
		fi

		if [ $escalaInicial == "Kelvin" -a $escalaFinal == "Fahrenheit" ]
		then
			temperatura=$(echo "(9*($valor-273.15)/5)+32" | bc -l)
		fi
	else
		zenity --error --text="Atenção: um erro ocorreu, verifique o valor inserido." --width="200"
		exit
	fi

	valorPort=$(printf "%0.2f" $valor | sed 's/\./,/g')
	temperaturaPort=$(printf "%0.2f" $temperatura | sed 's/\./,/g')

	if [ $escalaFinal == "Kelvin" ]
	then
		zenity --list --text="Resultado da conversão" --title="IEF829 - Informática no Ensino de Física" --width="400" \
		--ok-label="Finalizar" --cancel-label="Refazer" \
		--column="Escala $escalaInicial" --column="Escala $escalaFinal" \
		" $valorPort°" " $temperaturaPort"	

		status=$?
	else
		zenity --list --text="Resultado da conversão" --title="IEF829 - Informática no Ensino de Física" --width="400" \
		--ok-label="Finalizar" --cancel-label="Refazer" \
		--column="Escala $escalaInicial" --column="Escala $escalaFinal" \
		" $valorPort°" " $temperaturaPort°"
			
		status=$?
	fi
done

exit 0
