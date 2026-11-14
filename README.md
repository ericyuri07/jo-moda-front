# Jô Modas — app da loja de roupas

- **Aluno:** _(coloque seu nome aqui)_
- **Back-end escolhido:** **A — API REST Laravel** (`jo-moda-loja`: Laravel + Sanctum + MySQL)

## Descrição

App Flutter da loja Jô Modas. O cliente faz login, navega pelo catálogo (com
categorias, busca, preço promocional e parcelamento), vê os detalhes do produto,
monta o carrinho e fecha o pedido por WhatsApp (entrega com CEP via ViaCEP ou
retirada na loja). O administrador gerencia os produtos — **CRUD completo** de
`Product`, com os dados vindos da API.

Carrinho: guardado só no aparelho (`shared_preferences`); o pedido não é gravado no
back-end, é enviado por mensagem de WhatsApp.

## Telas e rotas (go_router, rotas nomeadas em `core/routes/`)

| Tela | Rota | Nome |
|---|---|---|
| Login | `/login` | `signIn` |
| Cadastro | `/cadastro` | `signUp` |
| Login do administrador | `/login-adm` | `adminSignIn` |
| Cadastro de administrador | `/cadastro-adm` | `adminSignUp` |
| Início (banner, categorias, produtos) | `/inicio` | `home` |
| Detalhes do produto | `/produto/:id` | `product` |
| Carrinho + entrega + WhatsApp | `/carrinho` | `cart` |
| Gerenciar produtos (admin) | `/admin/produtos` | `adminProducts` |
| Novo produto (admin) | `/admin/produtos/novo` | `adminProductNew` |
| Editar produto (admin) | `/admin/produtos/:id/editar` | `adminProductEdit` |
| Categorias (admin) | `/admin/categorias` | `adminCategories` |

Rotas `/admin*` só abrem para usuário com perfil admin (redirect no router).

## Estrutura

```
lib/
├── main.dart  app.dart
├── core/ (constants, routes, theme, utils)
├── models/    # fromJson/toJson, sem Flutter
├── services/  # API Laravel, carrinho, ViaCEP, WhatsApp
├── screens/   # auth, home, product, cart, admin
└── widgets/   # componentes reutilizáveis
```

## Como rodar

1. Suba o back-end (repositório separado, Docker; API em
   `http://localhost:8021/api`) com o banco populado
   (`php artisan migrate:fresh --seed`). Este projeto é **somente o front**.
2. Neste projeto:

```bash
flutter create . --project-name jo_modas   # gera android/ios/web (uma vez)
flutter pub get
flutter run -d chrome
```

Parâmetros opcionais (nada de URL/segredo fixo no código):

```bash
# emulador Android acessa o PC por 10.0.2.2
flutter run --dart-define=API_URL=http://10.0.2.2:8021/api \
            --dart-define=STORE_WHATSAPP=55DDDNUMERO
```

No Android, para HTTP (sem https) em desenvolvimento, adicione
`android:usesCleartextTraffic="true"` no `<application>` do `AndroidManifest.xml`.

Logo: exporte do Figma para `assets/images/logo.png`.

Contas de teste (seeder): `admin@jomodas.com` / `admin123` e
`cliente@jomodas.com` / `cliente123`.

Cliente e administrador entram por telas separadas: no login de cliente, toque
em **Entrar como ADM** para abrir o login ADM. Lá, "Não tem conta ADM?" leva
ao cadastro de administrador (nome, e-mail, senha e código de acesso). Cada
login só aceita o seu tipo de conta.

## Qualidade

```bash
dart format .
flutter analyze
flutter test
```

## Prints das telas

_(adicione aqui os prints: login, cadastro, início, detalhes, carrinho, admin)_
