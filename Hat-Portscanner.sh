#!/bin/bash
figlet Hat-portscanner | lolcat
echo "Você deseja realizar o portscan[S]im/[Não]?" | lolcat
read verifi

if [[ $verifi =~ ^(sim|s|SIM|S)$ ]]; then
    echo "Certo, agora passe o host que você deseja testar: " | lolcat
    read host
    sleep 1
    echo "Agora passe a porta: " | lolcat
    read port
    sleep 3
    echo "Iniciando o scan, aguarde um momento!!" | lolcat
    
    # Captura a saída do comando netcat com timeout de 10 segundos e redireciona erros para a mesma variável
    scan=$(netcat -zv -w 10 $host $port 2>&1)

    # Verifica se a saída contém a palavra "succeeded" indicando que a porta está aberta
    if [[ $scan == *"succeeded"* ]]; then
        echo "Porta $port ativa no host $host"
    elif [[ $scan == *"Connection refused"* ]]; then
        echo "A porta $port está fechada no host $host"
    elif [[ $scan == *"timed out"* ]]; then
        echo "A conexão com a porta $port no host $host expirou (timeout)"
    elif [[ $scan == *"Network is unreachable"* ]]; then
        echo "A rede não é acessível para o host $host na porta $port"
    elif [[ $scan == *"DNS fwd/rev mismatch"* ]]; then
        # Se DNS mismatch for encontrado, informa que o teste foi realizado e o estado da porta
        echo "Aviso de mismatch de DNS, mas o teste foi realizado com sucesso."
        
        # Aqui verificamos o status da porta novamente para informar se está aberta ou fechada
        if [[ $scan == *"succeeded"* ]]; then
            echo "Porta $port está aberta no host $host, apesar do erro de DNS."
        elif [[ $scan == *"Connection refused"* ]]; then
            echo "Porta $port está fechada no host $host, apesar do erro de DNS."
        fi
    else
        echo "Resposta inesperada: $scan"
    fi
else
    echo "Certo, saindo do portscanner, volte sempre :)!" | lolcat
fi

