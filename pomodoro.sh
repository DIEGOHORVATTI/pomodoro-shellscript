#!/bin/bash

### Função para mostras as opções de uso do programa
opcoes_de_uso(){
echo "Uso: $(basename "$0") [OPÇÔES]

OPÇÕES
  -p, --progressive	Inicia o cronometro em ordem progressiva
			Obs.:Para limitar o tempo na contagem progressiva,
			é necessário informar o tempo final no formato
			hh:mm:ss.

  -r, --regressive	Inicia o cronometro em ordem regressiva.
			Obs.: Necessário informar tempo inicial 
			no formato hh:mm:ss.

  -h, --help		Mostra esta tela de ajuda e sai

  -v, --version		Mostra a versão do programa e sai

EXEMPLOS DE USO: 
   $./pomodoro -p.................contagem progessiva infinita
   $./pomodoro -p 01:00:00........contagem progressiva de 1 hora
   $./pomodoro -r 01:00:00........contagem regressiva de 1 hora
" && exit 1
}

### Função que faz a conversão do tempo de segundos para o formato hh:mm:ss
calcula_tempo(){

if [ $TEMPO -lt 60 ] ; then
HORAS=0
MINUTOS=0
SEGUNDOS=$TEMPO

elif [ $TEMPO -lt 3600 ] ; then
HORAS=0
MINUTOS=$(($TEMPO / 60))
SEGUNDOS=$(($TEMPO % 60))

else
HORAS=$(($TEMPO / 3600))
RESTO=$(($TEMPO % 3600))
MINUTOS=$(($RESTO / 60))
SEGUNDOS=$(($RESTO % 60))

fi

# Após calculado o tempo, formata a saída para o padrão de 2 dígitos
HORASF=$(printf '%.2d' $HORAS)
MINUTOSF=$(printf '%.2d' $MINUTOS)
SEGUNDOSF=$(printf '%.2d' $SEGUNDOS)
}

### Função principal que atualiza o tempo na tela automaticamente
conta_tempo(){

#nome do pomodoro
read -p 'Nome: ' nomePomodoro

clear

# Se o operador não for negativo, define variável $TEMPO como -1
[ "$OP" = '-' ] || { TEMPO=-1 ; }

# Início do laço que atualiza o tempo na tela
while [ "$TECLA" != '(f|p)' ] && [ "$TEMPO_FINAL" -gt 0 ]
do
clear

TEMPO=$(($TEMPO $OP 1))
TEMPO_FINAL=$(($TEMPO_FINAL - 1))

# Chamada da função que converte o tempo para o formato hh:mm:ss a cada ciclo
# do loop.
calcula_tempo

# Feito os calculos, imprime na tela
   echo -e "\033[0;32m...........................\n\033]"
   echo -e "\033[0;32m| Start Pomodoro: $HORASF:$MINUTOSF:$SEGUNDOSF|\n| > $nomePomodoro \n\033]"
   echo -e "\033[0;32m...........................\n\033]"
   echo -e "\033[0;32m| [f]inalizar    [p]ausar |\n\033]"
   echo -e "\033[0;32m...........................\033]"
   read -n1 -t 1 TECLA  # Aguarda 1 segundo pela tecla, se não, continua

   # Conforme a tecla digitada, direciona para a função específica
   case "$TECLA" in
	f) finalizar ;;
	p) pausar ;;
	[[:alnum:]]) sleep 1 && continue ;; # Qualquer tecla exceto f e p,
   # aguarda 1 segundo e continua
  esac
done
Finalizar
}

### Função que mostra a tela final depois de encerrado o script
Finalizar(){
#voz pomodoro finalizado
paplay ./3.ogg
#musica de fundo 10s
paplay ./0.ogg
clear
   echo -e "\033[40;33;1m" "> Pomodoro" "'$nomePomodoro' "finalizado":$HORASF:$MINUTOSF:$SEGUNDOSF \033[m"
exit 0
}


### Função que faz pausa no tempo
pausar(){

while [ "$TECLA" != 'c' ] ; do
clear

   echo -e "\033[0;32m.............................\n\033]"
   echo -e "\033[0;32m| Pomodoro Pausado: $HORASF:$MINUTOSF:$SEGUNDOSF|\n| > $nomePomodoro \n\033]"
   echo -e "\033[0;32m.............................\n\033]"
   echo -e "\033[0;32m| [c]ontinuar   [f]inalizar |\n\033]"
   echo -e "\033[0;32m.............................\033]"
   
read -n1 -t 1 TECLA
   case "$TECLA" in
	f) finalizar ;;
   esac
done
}

### Função que mostra a versão atual do programa
versao() {
echo "v 1.0"
exit
}

### Função que testa e converte o parâmetro '$2' para segundos
teste_par2() {
# Testa formato de tempo passado no parâmetro 2. Deve ser hh:mm:ss
[[ "$TEMPO_LIMITE" != [0-9][0-9]:[0-5][0-9]:[0-5][0-9] ]] && \
echo "Tempo deve ser passado no formado hh:mm:ss" && exit 1

# Passado no teste do parâmetro '$2' faz a conversão para segundos
HORAS=$(echo $TEMPO_LIMITE | cut -d : -f 1) && HORAS=$(($HORAS * 3600))
MINUTOS=$(echo $TEMPO_LIMITE | cut -d : -f 2) && MINUTOS=$(($MINUTOS * 60))
SEGUNDOS=$(echo $TEMPO_LIMITE | cut -d : -f 3)
TEMPO=$(($HORAS+$MINUTOS+$SEGUNDOS+1))

TEMPO_FINAL=$TEMPO
conta_tempo
}

#################[ Tratamento das opções de linha de comando ]###############

# Testa se foi passado parâmetro '$1'
[ "$1" ] || { opcoes_de_uso ; } 

# Passado parâmetro '$1', faz o tratamento do mesmo
while test -n "$1"
do

   case "$1" in

   -p | --progressive) 
	OP=+ ; TEMPO=-1
	# Se tiver parâmetro 2, chama a funçao para teste do mesmo, caso não
	# tenha, define as variáveis e chama direto a função conta_tempo
	[ "$2" ] || { 
      TEMPO_FINAL=999999 ; conta_tempo ; 
   } 
   TEMPO_LIMITE=$2 && teste_par2;;

	-r | --regressive)
	# Testa se foi passado o parâmetro $2, que neste caso é obrigatório
	[ "$2" ] || {
      echo "Necessário informar o tempo inicial para \ início da contagem regressiva" 
      exit 1 
      }
      TEMPO_LIMITE=$2 ; OP=- && teste_par2;;

	-h | --help) opcoes_de_uso ;;
	-v | --version) versao ;;
   *) opcoes_de_uso ;;

   esac

done
