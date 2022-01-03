# pomodoro-shellscript
Um simples script de gerenciamento de tempo em .sh

```shell
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
```
