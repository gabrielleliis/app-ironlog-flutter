# Iron Log

Um aplicativo Flutter para rastreamento e análise de treinos.

## Descrição

Iron Log é um aplicativo mobile desenvolvido em Flutter que permite aos usuários registrar, acompanhar e analisar seus treinos de forma prática e intuitiva.

## Funcionalidades

- **Autenticação**: Sistema de login seguro
- **Dashboard**: Visualização geral dos treinos
- **Registro de Treinos**: Criação e gerenciamento de sessões de treino
- **Análise**: Estatísticas e insights sobre o desempenho

## Estrutura do Projeto

```
lib/
├── main.dart                 # Arquivo principal da aplicação
├── models/
│   └── workout_model.dart   # Modelo de dados para treinos
├── viewmodels/
│   └── workout_viewmodel.dart  # Lógica de negócios dos treinos
└── views/
    ├── analysis/
    │   └── analysis_view.dart     # Tela de análise
    ├── auth/
    │   └── login_view.dart        # Tela de login
    └── dashboard/
        └── dashboard_view.dart    # Tela principal (dashboard)
```

## Tecnologias Utilizadas

- **Flutter**: Framework para desenvolvimento mobile
- **Dart**: Linguagem de programação
- **Arquitetura MVVM**: Separação entre modelos, views e viewmodels

## Requisitos

- Flutter SDK (versão compatível)
- Dart SDK
- Android Studio ou Xcode (para emuladores)

## Instalação

1. Clone o repositório:
```bash
git clone https://github.com/gabrielleliis/app-ironlog-flutter
cd iron_log
```

2. Instale as dependências:
```bash
flutter pub get
```

3. Execute a aplicação:
```bash
flutter run
```

## Como Usar

1. Faça login na aplicação
2. Acesse o dashboard para visualizar seus treinos
3. Adicione novos treinos registrando seus exercícios
4. Consulte a seção de análise para acompanhar seu progresso

## Contribuição

Contribuições são bem-vindas! Sinta-se livre para abrir issues ou fazer pull requests.


## Autor

Desenvolvido por GABRIEL LELIS

---

Para mais informações, consulte a documentação do Flutter em: https://flutter.dev
