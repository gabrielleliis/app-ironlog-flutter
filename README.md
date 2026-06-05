# App Controle Financeiro

Solução mobile multiplataforma para gestão financeira pessoal, desenvolvida em Flutter. O aplicativo oferece rastreamento de receitas e despesas com cálculo automático de saldo, persistência local adaptada por plataforma e integração com feed de notícias do mercado financeiro via API REST.

## Arquitetura e Decisões Técnicas

O projeto prioriza escalabilidade e manutenção do código, adotando os seguintes padrões:

- **Padrão arquitetural MVVM**: separação clara entre Models (estruturas de dados), Views (interface) e ViewModels (lógica de negócio e orquestração de estado).
- **Gerenciamento de estado com Riverpod**: `StateNotifierProvider` expõe estado reativo para autenticação e transações, desacoplando a UI da lógica de persistência e regras de negócio.
- **Persistência híbrida por plataforma**: `DatabaseHelper` implementa o padrão Singleton com *conditional export* — SQLite (`sqflite`) em builds nativos (Android/iOS) e armazenamento em memória na Web, permitindo desenvolvimento e demonstração no navegador sem bloquear o fluxo principal.
- **Consumo de API externa**: integração com a API REST do [Finnhub](https://finnhub.io/) via `dio`, com tratamento de exceções, estados de carregamento (skeleton via `shimmer`) e degradação graciosa quando a API falha ou retorna dados incompletos.
- **UI reativa e defensiva**: validação de formulários com `GlobalKey<FormState>`, modais (`BottomSheet`) para CRUD sem troca de rota e carrossel de notícias com fallback visual para imagens ausentes ou inválidas.

## Funcionalidades Principais

- **Autenticação de usuários**: fluxo de login e cadastro com validação de campos obrigatórios.
- **Dashboard financeiro**: exibição reativa do saldo total (receitas − despesas).
- **Gestão de transações (CRUD)**: adição, listagem e remoção de entradas e saídas via `BottomSheet`, com cálculo de saldo atualizado automaticamente.
- **Feed de notícias**: carrossel (`carousel_slider`) com manchetes financeiras em tempo real, autoplay, skeleton loading e tratamento de imagens quebradas na origem.

## Stack Tecnológico

| Camada | Tecnologia |
|---|---|
| Framework | Flutter |
| Linguagem | Dart `^3.12` |
| Estado | `flutter_riverpod` |
| Banco de dados | `sqflite`, `path_provider`, `path` |
| HTTP | `dio` |
| UI/UX | `shimmer`, `carousel_slider`, Material 3 |

## Estrutura de Diretórios

```text
lib/
├── main.dart                     # Entry point e ProviderScope
├── models/
│   ├── user_model.dart           # Entidade de usuário
│   └── transaction_model.dart    # Entidade de transação
├── services/
│   ├── db_helper.dart            # Export condicional (mobile / web)
│   ├── db_helper_mobile.dart     # SQLite para Android e iOS
│   ├── db_helper_web.dart        # Persistência em memória para Web
│   └── api_service.dart          # Cliente HTTP — notícias Finnhub
├── viewmodels/
│   ├── auth_viewmodel.dart       # AuthNotifier + authProvider
│   └── transaction_viewmodel.dart # TransactionNotifier + transactionProvider
└── views/
    ├── login_screen.dart         # Tela de login
    ├── register_screen.dart      # Tela de cadastro
    └── dashboard_screen.dart     # Dashboard, CRUD e feed de notícias
```

## Pré-requisitos

- [Flutter SDK](https://docs.flutter.dev/get-started/install) compatível com Dart `^3.12`
- Chrome (recomendado para execução Web)
- Conta gratuita no [Finnhub](https://finnhub.io/) para obter um token de API

## Como Executar o Projeto

**1. Clone o repositório**

```bash
git clone https://github.com/gabrielleliis/app-ironlog-flutter.git
cd app-ironlog-flutter
```

**2. Instale as dependências**

```bash
flutter pub get
```

**3. Configure o token da API**

Em `lib/services/api_service.dart`, substitua o valor do parâmetro `token` na URL pelo seu token do Finnhub:

```dart
const String url =
    'https://finnhub.io/api/v1/news?category=general&token=SEU_TOKEN_AQUI';
```

**4. Execute a aplicação**

Web (recomendado para desenvolvimento rápido):

```bash
flutter run -d chrome
```

Android / iOS:

```bash
flutter run
```

> **Nota (Windows):** se o projeto utilizar plugins nativos, pode ser necessário habilitar o *Developer Mode* nas configurações do sistema para suporte a symlinks durante o build.

## Fluxo de Uso

1. Na tela de login, cadastre um usuário ou autentique-se com credenciais existentes.
2. No dashboard, visualize o saldo total e o carrossel de notícias financeiras.
3. Utilize o botão flutuante (`+`) para registrar receitas ou despesas.
4. Remova transações diretamente na listagem, quando necessário.

## Autor

Desenvolvido por **Gabriel Lelis Costa Santos**.
