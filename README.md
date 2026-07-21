# Flutter Cash Calc 💰

Calculadora de juros compostos desenvolvida em Flutter e Dart. Permite calcular, de forma isolada, cada uma das variáveis envolvidas em uma aplicação financeira (montante, capital inicial, aporte mensal, taxa de juros e período).

## Funcionalidades

- 💵 **Montante**: calcula o valor final acumulado a partir do capital inicial, aporte mensal, taxa de juros e período
- 🏦 **Capital Inicial**: calcula quanto seria necessário investir inicialmente para atingir um montante desejado
- 📈 **Rentabilidade (Taxa de Juros)**: calcula a taxa de juros necessária para atingir um objetivo financeiro
- 📅 **Aporte Mensal**: calcula o valor de contribuição mensal necessário para atingir a meta
- ⏳ **Período**: calcula o tempo necessário para atingir o montante desejado
- 🔁 Suporte a taxas de juros e períodos informados em bases mensal ou anual

## Como executar

### Pré-requisitos
- [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado (Dart SDK ^3.10.7)
- Um emulador Android/iOS configurado, um navegador (para Flutter Web) ou um dispositivo físico conectado

### Passos

```bash
# 1. Acesse a pasta do projeto
cd Flutter_Cash_Calc

# 2. Instale as dependências
flutter pub get

# 3. Verifique os dispositivos disponíveis
flutter devices

# 4. Execute o aplicativo
flutter run
```

Para rodar em uma plataforma específica:

```bash
flutter run -d chrome     # Web
flutter run -d windows    # Windows
flutter run -d macos      # macOS
flutter run -d linux      # Linux
```

Para gerar um build de produção (exemplo Android):

```bash
flutter build apk --release
```