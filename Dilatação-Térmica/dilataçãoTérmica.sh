#!/bin/bash

##################################################################################################################
# dilataçãoTérmica.sh  é um programa que foi desenvolvido, com fins didáticos, durante a disciplina          	 #
# IEF829 - Informática no Ensino de Física, oferecida pelo Departamento de Física do Instituto de Ciências       #
# Exatas da Universidade Federal do Amazonas, durante o 1° Semestre letivo de 2022. Ele foi desenvolvido com o   #
# objetivo de mostrar aos estudantes do curso de Licenciatura em Física que é possível criar softwares           #
# relacionados à conteúdos de Física, os quais podem ser usados como ferramenta didática durante os processos    # 
# de ensino e aprendizagem.                                                                                      #
# Copyright (C) <2023>  <J.R.M. Monteiro > | e-mail: joziano@protonmail.com | Version 1, Feb 2023                #
##################################################################################################################

############################################################################################ d ###################
# LICENSE INFORMATION                                                     ################## i ###################
#                                                                         ################## l ###################
# This program is free software: you can redistribute it and/or modify    ################## a ###################
# it under the terms of the GNU General Public License as published by    ################## t ###################
# the Free Software Foundation, either version 3 of the License, or       ################## a ###################
# (at your option) any later version.                                     ################## c ###################
#                                                                         ################## a ###################
# This program is distributed in the hope that it will be useful,         ################## o ###################
# but WITHOUT ANY WARRANTY; without even the implied warranty of          ################## T ###################
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the           ################## e ###################
# GNU General Public License for more details.                            ################## r ###################
#                                                                         ################## m ###################
# You should have received a copy of the GNU General Public License       ################## i ###################
# along with this program.  If not, see <https://www.gnu.org/licenses/>5. ################## c a . s h ###########
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
	Ele realiza o cálculo do coeficiente de dilatação para as barras
	feitas de Alumínio, Cobre e Latão, utilizando os dados coletados
	durante o experimento de Dilatação Térmica, do Laboratório de Ondas
	e calor.
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

# Agora iremos criar a interface gráfica usando o zenity. Esta interface gráfica inicial
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

# Interface gráfica do zenity para coleta dos dados do experimento de dilatação
# Os dados serão armazenados no arquivo dados.txt

zenity --forms \
	--title="IEF829 - Informática no Ensino de Física" \
	--text="Dilatação Térmica - Laboratório de Ondas e Calor" \
	--add-entry="Temperatura inicial (°C)" \
	--add-entry="Temperatura Final (°C)" \
	--add-combo="Material da Barra" \
	--combo-values="Latão|Alumínio|Cobre" \
	--add-entry="Comprimento inicial da barra (mm)" \
	--add-entry="Variação do comprimento (mm)" > dados.txt

# Adicionaremos a condição para que se o status do passo anterior for diferente de zero, o programa
# seja encerrado. Se o botão OK for pressionado, o status será 0. Se o botão cancelar ou o X forem 
# pressionados, o status será diferente de 0.

if [ $? != 0 ]
then
	exit
fi	

# Iremos armazenar os dados preenchidos no formulário e armazenados no arquivo dados.txt
# nas suas respectivas variáveis.

temperaturaInicial=$(cut -d \| -f1 dados.txt)
temperaturaFinal=$(cut -d \| -f2 dados.txt)
materialBarra=$(cut -d \| -f3 dados.txt)
comprimentoInicial=$(cut -d \| -f4 dados.txt)
varComprimento=$(cut -d \| -f5 dados.txt)

# Iremos verificar se as variáveis estão vazias. Em caso afirmativo, um erro será exibido e
# o programa será encerrado.

if [ -z $temperaturaInicial ]
then
	zenity --error --text="ERRO... Campo da Temperatura inicial está vazio." --width="400"
	exit
fi

if [ -z $temperaturaFinal ]
then
	zenity --error --text="ERRO... Campo da Temperatura final está vazio." --width="400"
	exit
fi

if [ -z $materialBarra ]
then
	zenity --error --text="ERRO... Campo Material da barra está vazio." --width="400"
	exit
fi

if [ -z $comprimentoInicial ]
then
	zenity --error --text="ERRO... Campo comprimento inicial está vazio." --width="400"
	exit
fi

if [ -z $varComprimento ]
then
	zenity --error --text="ERRO... Campo variação do comprimento está vazio." --width="400"
	exit
fi

# Superada as etapas anteriores, precisamos verificar se os valores inseridos
# no formulário são reais, e não um caractere especial, por exemplo @ ou &.

if ! [[ $temperaturaInicial  =~ ^-?[0-9]+([.][0-9]+)?$ ]]
then
	zenity --error --text="ERRO... Campo comprimento inicial com valor inválido." --width="400"
	exit
fi

if ! [[ $temperaturaFinal  =~ ^-?[0-9]+([.][0-9]+)?$ ]]
then
	zenity --error --text="ERRO... Campo da Temperatura final com valor inválido." --width="400"
	exit
fi

if ! [[ $comprimentoInicial  =~ ^-?[0-9]+([.][0-9]+)?$ ]]
then
	zenity --error --text="ERRO... Campo comprimento inicial com valor inválido." --width="400"
	exit
fi

if ! [[ $varComprimento  =~ ^-?[0-9]+([.][0-9]+)?$ ]]
then
	zenity --error --text="ERRO... Campo variação do comprimento com valor inválido." --width="400"
	exit
fi

# Superado os passos anteriores, iremos calcular o coeficiente de dilatação linear

varTemperatura=$(echo $temperaturaFinal-$temperaturaInicial | bc -l)
denominador=$(echo $comprimentoInicial*$varTemperatura | bc -l)
alpha=$(echo $varComprimento/$denominador | bc -l)

if [ $materialBarra == "Alumínio" ]
then
	valorLiteratura="0.000023"
fi

if [ $materialBarra == "Latão" ]
then
	valorLiteratura="0.000019"
fi

if [ $materialBarra == "Cobre" ]
then
	valorLiteratura="0.000017"
fi

zenity --list --text="Resultado - Experimento de Dilatação Térmica" \
--title="IEF829 - Informática no Ensino de Física" --width="600" \
--ok-label="Finalizar" --cancel-label="Cancelar" \
--column="Material da Barra" --column="Coeficiente de dilatação obtido " --column="Valor na literatura" \
"$materialBarra" " $(printf "%E" $alpha)/°C" " $(printf "%E" $valorLiteratura)/°C"

exit
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
