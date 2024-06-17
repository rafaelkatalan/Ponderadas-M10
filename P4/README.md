# Aplicativo de Filtro de Imagem

Este projeto consiste em um aplicativo desenvolvido com Flutter para o frontend e três microserviços distintos para funcionalidades de backend. O aplicativo permite o envio de imagens, que são processadas para remoção de fundo, e posteriormente visualizadas pelo usuário. O NGINX é utilizado como gateway para rotear as requisições para os serviços adequados, e todas as chamadas nos endpoints são logadas pelo NGINX e posteriormente processadas e armazenadas no serviço de log.

## Serviços

### Serviço 1 - user_service

Este serviço é responsável pelo gerenciamento de usuários e autenticação. É composto por um container com um backend em Python (FastApi), que oferece endpoints para criação de usuários e login.

### Serviço 2 - notification_service

Este serviço é encarregado da edição de imagens e notificação. É composto por um container com um backend em Python (FastApi), que oferece endpoints para envio e recebimento de imagens, e realiza a edição das imagens utilizando a biblioteca OpenCV. Após o processamento bem-sucedido da imagem, o serviço notifica o frontend com uma mensagem de sucesso.

### Serviço 3 - log_service

Este serviço registra informações sobre as ações realizadas no sistema, contribuindo para o monitoramento e auditoria das operações. Ele recebe logs do NGINX, registra logs de login de usuários e de ações relacionadas ao envio de imagens. É composto por um container com um backend em Python (FastApi) que processa e armazena os logs. Utiliza um banco de dados PostgreSQL para armazenamento.

## NGINX e Logs

O NGINX atua como um gateway para o roteamento de requisições para os serviços adequados. Além disso, todas as chamadas nos endpoints são registradas pelo NGINX. Esses registros são posteriormente processados pelo serviço de log, onde são armazenados no banco de dados PostgreSQL. O serviço de log também registra informações de login de usuários e ações relacionadas ao envio de imagens.

## Frontend (Flutter)

O frontend foi desenvolvido em Flutter, um framework para desenvolvimento de aplicativos móveis multiplataforma. O aplicativo inclui as seguintes telas:
- Tela de login
- Tela inicial
- Tela de envio de imagem
- Tela de galeria, onde é possível visualizar as imagens já processadas

## Como Utilizar

Para executar o aplicativo, siga os passos abaixo:

1. Clone o repositório em sua máquina.
2. Certifique-se de ter o Docker instalado.
3. Dentro do diretório, execute no terminal `docker-compose up`.
4. Para executar o frontend, conecte seu dispositivo móvel ou inicie um emulador e execute o comando `flutter run` para iniciar o aplicativo.

As rotas do backend estão configuradas para `localhost`. Caso deseje rodar o frontend em um dispositivo externo, ajuste as rotas para que possam acessar corretamente cada um dos microserviços.
