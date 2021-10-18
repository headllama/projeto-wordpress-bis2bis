# Desafio bis2bis
Repositorio contendo o wordpress + mysql + prometheus + grafana + argoCD

Utilizei o Makefile para separar os desafios em parte, facilitando a analise do projeto, para isso tera que ter o *make* instalado em sua máquina através do comando `sudo apt install make`.

Após clonar esse repositório com o comando `git clone https://github.com/headllama/projeto-wordpress-bis2bis`, iniciaremos o minikube com o comando `make minikube`. 

Para fazer deploy da primeira parte - que constitui no ambiente wordpress e mysql - para isso, daremos o comando `make step-1`. Após os pods subirem, deveremos pegar o IP da aplicação utilizando o script `./script.sh wordpress`, acessando em seu navegador o wordpress.

Para rodar as ferramentas de monitoramento, daremos o comando `make step-2`, que fará o deployment das ferramentas no ambiente `monitoring` - em seguida, para acessar o grafana utilizaremos o script com o comando `./script.sh grafana`, em seguida acessamos o `localhost:3000` - username e password: admin. 
- Deveremos importar o json: Apos o login no grafana, com o mouse em cima do sinal **+** na lateral esquerda, clicaremos em import e upload JSON file, selecionando o arquivo `dashboard.json` na raiz desse projeto. 

Para rodar o nossa ferramenta de CI/CD, daremos o comando `make step-3`, que sera feito o deployment no namespace `argocd`, para acessar o Argo, utilizaremos o script com o comando `./script.sh argo` e acessaremos o `localhost:8080`. O login e admin e, como a primeira senha eh gerada de forma dinâmica, utilizaremos o script `./script.sh argo-passwd`. Ao acessar, teremos que configurar manualmente o projeto, clicando em `new app` e definindo o nome da app, repositorio e cluster.


## Em produção
Como o ambiente de produção terá algumas diferenças com esse ambiente - de teste - ressalto que:

- Como utilizaremos volumes estaticos (como nfs) e um db nativo da plataforma de nuvem, nao será necessário ficar incorporando manualmente o json da dashboard do Grafana após a primeira vez; também não sera necessaria a incorporação de dados manuais no database com frequência.

- Como repositório de senhas, poderemos utilizar o gitlab ou o Vault para a perfeita segurança das mesmas.

- Assumo tambem que utilizaremos um container próprio, para isso poderemos utilizar o [gitlab container registry] (https://docs.gitlab.com/ee/user/packages/container_registry/) para gerar nossos containers de forma privada dentro do gitlab; para isso utilizaremos o [Kaniko](https://github.com/GoogleContainerTools/kaniko) com a seguinte pipeline `gitlab-ci.yaml.kaniko` que funcionára da seguinte maneira: Ao satisfazer a condicao de trigger (exemplo, um merge request) e apos os testes unitários, será criada a imagem docker de forma privada no gitlab, essa criação irá gerar um sinal para o deployment do wordpress (modificando o nome da sua imagem por meio de um simples shell script) e, por meio do ArgoCD, gerará um deploy para o ambiente de QA; em seguida sera incorporado ao ambiente de produção através de estratégias de deployment como o blue/green ou o canary deploy.

- Entendo que as configuracoes do ArgoCD tambem foram aquém do desejado no teste, mas como em produção somente faremos isso uma vez e essa eh uma ótima ferramenta para CD, preferi utilizá-la
