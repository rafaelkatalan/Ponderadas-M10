# To-Do List App

Este é um aplicativo de lista de tarefas simples, composto por um frontend em Flutter e um backend em FastAPI. O aplicativo permite que os usuários visualizem, adicionem e marquem tarefas como concluídas.

## Arquitetura

O projeto é dividido em dois componentes principais:

### Frontend (Flutter)

O frontend é desenvolvido em Flutter, um framework de desenvolvimento de aplicativos móveis multiplataforma. Ele fornece uma interface de usuário amigável para interagir com a lista de tarefas.

### Backend (FastAPI)

O backend é construído com o FastAPI, um framework web rápido para Python. Ele gerencia a lógica de negócios, como ler, adicionar e marcar tarefas como concluídas, e se comunica com o banco de dados PostgreSQL para armazenar os dados das tarefas.

O banco de dados PostgreSQL é utilizado para armazenar as tarefas e está containerizado para facilitar a configuração e o gerenciamento.

## Como Usar

Siga estas etapas para configurar e executar o aplicativo:

1. **Configuração do Backend**:
   - Certifique-se de ter o Python e o FastAPI instalados em seu ambiente.
   - Clone o repositório e navegue até o diretório do backend.
   - Execute `pip install -r requirements.txt` para instalar as dependências do projeto.
   - Inicie o servidor backend executando `uvicorn main:app --reload`.

2. **Configuração do Banco de Dados**:
   - Certifique-se de ter o Docker instalado em seu sistema.
   - Execute `docker-compose up -d` para iniciar o contêiner do PostgreSQL.

3. **Configuração do Frontend**:
   - Certifique-se de ter o Flutter instalado em seu ambiente de desenvolvimento.
   - Clone o repositório e navegue até o diretório do frontend.
   - Execute `flutter pub get` para instalar as dependências do projeto.

4. **Execução do Aplicativo**:
   - Conecte seu dispositivo móvel ou inicie um emulador.
   - Execute `flutter run` para iniciar o aplicativo.

5. **Uso do Aplicativo**:
   - Use a interface do aplicativo para visualizar, adicionar e marcar tarefas como concluídas.

## Demonstração

Veja o aplicativo em ação [neste vídeo demonstrativo](https://drive.google.com/file/d/1PpzQydjVbbkQ9itP0bVVRhYz0-CdBw76/view?usp=sharing).
