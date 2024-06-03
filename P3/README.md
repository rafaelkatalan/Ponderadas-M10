# Aplicativo de Filtro de Imagem

Este projeto consiste em um aplicativo desenvolvido com Flutter para o frontend e três microserviços distintos para funcionalidades de backend. O aplicativo permite o envio de imagens, que são processadas para remoção de fundo, e posteriormente visualizadas pelo usuário.

## Serviços

### Serviço 1 - user_service

Este serviço é responsável pelo gerenciamento de usuários e autenticação. Ele é composto por dois containers:
- Um container com um banco de dados PostgreSQL que armazena as informações dos usuários.
- Um container com um backend em Python (FastApi), que oferece endpoints para criação de usuários e login.

### Serviço 2 - notification_service

Este serviço é encarregado da edição de imagens e notificação. Ele também é composto por dois containers:
- Um container com um banco de dados PostgreSQL para armazenar as imagens.
- Um container com um backend em Python (FastApi), que oferece endpoints para envio e recebimento de imagens, e realiza a edição das imagens utilizando a biblioteca OpenCV. Após o processamento bem-sucedido da imagem, o serviço notifica o frontend com uma mensagem de sucesso.

### Serviço 3 - log_service

Este serviço registra informações sobre as ações realizadas no sistema, contribuindo para o monitoramento e auditoria das operações. Assim como os outros, ele utiliza um banco de dados PostgreSQL e um backend em Python (FastApi)

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
3. Dentro das pastas `log_service`, `notification_service` e `user_service`, execute o comando `docker-compose up` no terminal.
4. Para executar o frontend, conecte seu dispositivo móvel ou inicie um emulador, e execute o comando `flutter run` para iniciar o aplicativo.

As rotas do backend estão configuradas para `localhost`. Caso deseje rodar o frontend em um dispositivo externo, ajuste as rotas para que possam acessar corretamente cada um dos microserviços.

## Demonstração

Confira o aplicativo em ação no [vídeo demonstrativo](https://drive.google.com/file/d/1OCZEVgqeBx64NYeD1mPT4dxPOTEv3NAj/view?usp=sharing).