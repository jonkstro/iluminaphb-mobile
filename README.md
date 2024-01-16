[![Open Source](https://badges.frapsoft.com/os/v1/open-source.svg?v=103)](https://opensource.org/)
![Dart Version](https://img.shields.io/static/v1?label=dart&message=3.1.5&color=00579d)
![Flutter Version](https://img.shields.io/static/v1?label=flutter&message=3.13.9&color=42a5f5)
![Null Safety](https://img.shields.io/static/v1?label=null-safety&message=done&color=success)


# IluminaPHB - Aplicativo Móvel - Frontend
## Vídeo Demonstrativo

<video width="200" controls>
  <source src="video-demonstracao.mp4" type="video/mp4">
  Seu navegador não suporta o elemento de vídeo.
</video>



## 🚀 Configurando para Utilizar

### Instalação Flutter


Para iniciar o projeto antes de mais nada certifique-se que o Flutter SDK está instalado e configurado corretamente em sua máquina e que está usando a versão mais recente. 

É possível fazer essa verificação utilizando o comando abaixo:
```
flutter doctor
```
Caso você não possua o Flutter instalado a [Documentação Oficial](https://docs.flutter.dev/get-started/install) oferece instruções detalhas de como fazer todas as configurações necessárias.

### Inicializando o Projeto


Atraves do terminal, faça o clone do repositorio em uma pasta usando o comando:

```
git clone https://github.com/jonkstro/iluminaphb-mobile.git
```
Acesse a pasta com o comando:

```
cd iluminaphb-mobile
```

Faça a instalação dos pacotes nescesarios:
```
flutter pub get
```
Abra o projeto utilizando o comando:
```
code .
```
---


> ## Packages and Tools
* **cupertino_icons:**
   - Fornece ícones no estilo Cupertino para aplicativos Flutter, seguindo o design do iOS.

* **provider:**
   - Facilita a gestão de estado em aplicativos Flutter, permitindo o compartilhamento eficiente de dados entre widgets.

* **intl:**
   - Oferece suporte à internacionalização (i18n) em aplicativos Flutter, possibilitando a tradução de mensagens e formatação de datas, números, etc.

* **http:**
   - Simplifica a realização de solicitações HTTP em aplicativos Flutter, permitindo a comunicação com servidores web.

* **emailjs:**
   - Utilizado para enviar e-mails através de serviços de envio de e-mails, integrando funcionalidades de e-mail ao aplicativo Flutter.

* **shared_preferences:**
   - Permite a persistência de dados simples, como configurações do aplicativo, utilizando o armazenamento local no dispositivo.

* **flutter_dotenv:**
   - Facilita o carregamento de variáveis de ambiente (env variables) em aplicativos Flutter, geralmente usado para armazenar configurações sensíveis.

* **flutter_localizations:**
   - Fornece suporte para localizações específicas de idiomas no Flutter, sendo uma parte essencial para internacionalização (i18n) em aplicativos Flutter.


> ## Features Dart/Flutter
### Desenvolvimento do Aplicativo Móvel

O aplicativo móvel será construído com o framework Flutter, proporcionando uma experiência eficiente e uniforme em várias plataformas móveis. O Flutter é reconhecido por sua capacidade de criar interfaces de usuário ricas e responsivas, tornando-o uma escolha ideal para o desenvolvimento do aplicativo de gestão de iluminação pública municipal.

### Arquitetura do Frontend

O frontend do aplicativo será estruturado usando o Flutter, que utiliza a linguagem Dart. O Flutter segue uma arquitetura baseada em widgets, oferecendo flexibilidade no design da interface do usuário e na implementação de funcionalidades interativas.

### Tecnologias Principais

- **Flutter:**
  - O Flutter será a principal tecnologia no desenvolvimento do aplicativo móvel.
  - Abordagem de compilação ahead-of-time (AOT) para desempenho rápido e interfaces suaves.
  - Vantagem distintiva de portabilidade para desenvolvimento em Android e iOS com o mesmo código base.

### Funcionalidades do Frontend

1. **Registro de Manutenções:**
   - Interface intuitiva para registro e consulta de manutenções relacionadas à iluminação pública.

2. **Registro de Reclamações:**
   - Funcionalidade amigável para usuários registrarem reclamações sobre iluminação deficiente.

3. **Mapeamento de Pontos sem Iluminação:**
   - Mapas interativos para identificar e visualizar locais sem instalação de iluminação pública.

4. **Registro de Consumo de Serviços e Materiais:**
   - Interface fácil de usar para registrar o consumo de serviços e materiais em cada manutenção.

5. **Integração com GPS:**
   - Utilização do GPS para uma localização precisa em novos pontos de instalação.

6. **Autenticação Segura:**
   - Interface de login segura para garantir acesso controlado ao sistema.

7. **Notificações em Tempo Real:**
   - Recebimento de notificações em tempo real sobre o andamento das manutenções.

8. **Relatórios de Desempenho:**
   - Visualização de relatórios periódicos sobre o desempenho do sistema e das manutenções realizadas.

### Requisitos Não Funcionais do Frontend

1. **Responsividade:**
   - Garantir uma experiência de usuário responsiva em diferentes tamanhos de tela.

2. **Compatibilidade com Plataformas:**
   - Certificar-se de que o aplicativo seja compatível com as principais plataformas móveis, como Android e iOS.

3. **Desempenho:**
   - Garantir resposta rápida e transições suaves para uma experiência de usuário agradável.

4. **Segurança da Interface:**
   - Implementar práticas de segurança na interface do usuário para proteger dados sensíveis.

5. **Usabilidade Intuitiva:**
   - Projetar uma interface intuitiva para facilitar a navegação e o uso por usuários de diferentes níveis de habilidade.

6. **Notificações Push:**
   - Implementar notificações push para manter os usuários informados sobre eventos importantes no sistema.

O uso do Flutter no desenvolvimento do aplicativo móvel garantirá uma aplicação consistente, eficiente e fácil de usar para a gestão de iluminação pública municipal, além da vantagem de portabilidade entre diferentes plataformas (Android ou iOS).

> ## Features Tests
* --