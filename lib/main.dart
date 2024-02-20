import 'package:flutter/material.dart';
import 'package:iluminaphb/enums/tipo_solicitacao_enum.dart';
import 'package:iluminaphb/models/auth.dart';
import 'package:iluminaphb/models/request_list.dart';
import 'package:iluminaphb/models/service_order_finish.dart';
import 'package:iluminaphb/models/service_order_finish_list.dart';
import 'package:iluminaphb/models/service_order_list.dart';
import 'package:iluminaphb/pages/background_page.dart';
import 'package:iluminaphb/pages/service_request_form_page.dart';
import 'package:iluminaphb/pages/splash_page.dart';
import 'package:iluminaphb/pages/unknown_page.dart';
import 'package:iluminaphb/utils/app_routes.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// Ajustar o sistema para PT-BR
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  // Carregar as variáveis de ambiente
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Vou dizer aqui que não vou deixar a aplicação rodar pro lado.
    // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    var brilho = MediaQuery.of(context).platformBrightness;
    // Vai ver se a variavel brilho tá igual escuro
    bool isDarkMode = brilho == Brightness.dark;
    var corTextoPadrao = isDarkMode
        ? const Color.fromRGBO(251, 251, 251, 1)
        : const Color.fromRGBO(113, 92, 248, 1);
    var corTextoCorpo = isDarkMode
        ? const Color.fromRGBO(255, 255, 255, 0.8)
        : const Color.fromRGBO(0, 0, 0, 0.8);

    return MultiProvider(
      // Criar os Providers que serão utilizados no projeto
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),

        /// QUANDO FOR ADICIONAR AUTENTICAÇÃO PRA BUSCAR SOLICITAÇÕES POR USUÁRIO - INÍCIO
        ChangeNotifierProxyProvider<Auth, RequestList>(
          // Iniciar com token vazio e lista vazia já no construtor
          create: (_) => RequestList(),
          update: (ctx, auth, previous) {
            // Vai retornar o ProductList quando atualizar token
            return RequestList(
              auth.token ?? '',
              auth.userId ?? '',
              previous?.itens ?? [],
            );
          },
        ),
        ChangeNotifierProxyProvider<Auth, ServiceOrderList>(
          create: (_) => ServiceOrderList(),
          update: (ctx, auth, previous) {
            return ServiceOrderList(
              auth.token ?? '',
              auth.userId ?? '',
              previous?.itens ?? [],
            );
          },
        ),
        ChangeNotifierProxyProvider<Auth, ServiceOrderFinishList>(
          create: (_) => ServiceOrderFinishList(),
          update: (ctx, auth, previous) {
            return ServiceOrderFinishList(
              auth.token ?? '',
              auth.userId ?? '',
              previous?.itens ?? [],
            );
          },
        ),

        /// QUANDO FOR ADICIONAR AUTENTICAÇÃO PRA BUSCAR SOLICITAÇÕES POR USUÁRIO - FINAL
      ],
      child: MaterialApp(
        /// Ajustar o programa pra PT-BR [DatePickers, Dias semana, Copiar e colar, etc]
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [Locale('pt', 'BR')],
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            error: Colors.red.shade900,
          ),
          fontFamily: 'QuickSand',
          // mudar a cor dos icones de voltar da appbar
          iconTheme: IconThemeData(color: corTextoCorpo),
          inputDecorationTheme: InputDecorationTheme(
            fillColor: isDarkMode
                ? const Color.fromRGBO(0, 0, 0, 0.8)
                : const Color.fromRGBO(255, 255, 255, 0.8),
            filled: true,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(50),
              ),
            ),
            labelStyle: TextStyle(
              fontSize: 16 * MediaQuery.of(context).textScaleFactor,
              color: corTextoCorpo,
            ),
          ),
          textTheme: TextTheme(
            headlineSmall: TextStyle(
              fontSize: 30 * MediaQuery.of(context).textScaleFactor,
              fontWeight: FontWeight.bold,
              color: corTextoCorpo,
            ),
            headlineMedium: TextStyle(
              fontSize: 40 * MediaQuery.of(context).textScaleFactor,
              fontWeight: FontWeight.bold,
              color: corTextoPadrao,
            ),
            headlineLarge: TextStyle(
              fontFamily: 'Compiler',
              // Se for tablet vai aumentar a fonte
              fontSize: 40 * MediaQuery.of(context).textScaleFactor,
              // fontWeight: FontWeight.bold,
            ),
            bodySmall: TextStyle(
              fontSize: 16 * MediaQuery.of(context).textScaleFactor,
              fontWeight: FontWeight.normal,
              color: corTextoCorpo,
            ),
            bodyMedium: TextStyle(
              fontSize: 20 * MediaQuery.of(context).textScaleFactor,
              fontWeight: FontWeight.bold,
              color: corTextoPadrao,
            ),
            bodyLarge: TextStyle(
              fontSize: 25 * MediaQuery.of(context).textScaleFactor,
              fontWeight: FontWeight.normal,
              // Cor dos botões de selecionar serviço
              color: const Color.fromRGBO(0, 0, 0, 0.8),
            ),
            labelSmall: TextStyle(
              fontSize: 16 * MediaQuery.of(context).textScaleFactor,
              fontWeight: FontWeight.normal,
              color: corTextoCorpo,
            ),
            labelMedium: TextStyle(
              fontSize: 16 * MediaQuery.of(context).textScaleFactor,
              fontWeight: FontWeight.bold,
              color: corTextoCorpo,
            ),
            labelLarge: TextStyle(
              fontSize: 18 * MediaQuery.of(context).textScaleFactor,
              fontWeight: FontWeight.bold,
              color: const Color.fromRGBO(0, 0, 0, 0.8),
            ),
          ),
        ),
        // remover aquela lista de debug
        debugShowCheckedModeBanner: false,
        home: const SplashPage(),
        routes: {
          AppRoutes.HOME: (context) => const BackgroundPage(),
          // AppRoutes.EMAIL_VALIDATION: (context) => const EmailValidationPage(),
          AppRoutes.FORM_INSTALACAO: (context) => const ServiceRequestFormPage(
                tipoSolicitacao: TipoSolicitacaoEnum.INSTALACAO,
              ),
          AppRoutes.FORM_MANUTENCAO: (context) => const ServiceRequestFormPage(
                tipoSolicitacao: TipoSolicitacaoEnum.MANUTENCAO,
              ),
        },
        // Se não achar nenhuma rota vai abrir a "Página 404" igual na WEB
        onUnknownRoute: (settings) {
          return MaterialPageRoute(
            builder: (_) {
              return const UnknownPage();
            },
          );
        },
      ),
    );
  }
}
